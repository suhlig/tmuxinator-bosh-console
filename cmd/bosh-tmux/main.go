package main

import (
	"fmt"
	"html/template"
	"io/ioutil"
	"os"
	"os/user"
	"path/filepath"

	"gopkg.in/yaml.v2"

	boshdir "github.com/cloudfoundry/bosh-cli/director"
	boshlog "github.com/cloudfoundry/bosh-utils/logger"
)

func main() {

	// TODO Read alias from -e
	env := "vbox"

	director, err := buildDirector(env)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	deps, err := director.Deployments()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	// TODO If deployment was given, print only the instances of this one
	// TODO take environment with -e
	// TODO If an instance filter was given, print only the matching ones

	for _, dep := range deps {
		printInstancesCommand(env, dep)
	}
}

type Info struct {
	Environment string
	Deployment  boshdir.Deployment
	Instance    boshdir.VMInfo
}

func printInstancesCommand(environment string, deployment boshdir.Deployment) {
	t := template.New("bosh console")
	t, _ = t.Parse("bosh -e {{ .Environment }} -d {{ .Deployment.Name }} ssh {{ .Instance.JobName }}/{{ .Instance.ID }}\n")

	instances, _ := deployment.InstanceInfos()

	for _, inst := range instances {
		info := Info{
			Environment: environment,
			Deployment:  deployment,
			Instance:    inst,
		}

		// TODO Write to ~/.tmuxinator/{{ .Deployment.Name }}.yml and complain if it exists and there is no --force given
		t.Execute(os.Stdout, info)
	}
}

type BoshConfig struct {
	Environments []Environment `yaml:"environments"`
}

type Environment struct {
	URL      string `yaml:"url"`
	CACert   string `yaml:"ca_cert,omitempty"`
	Alias    string `yaml:"alias,omitempty"`
	Username string `yaml:"username,omitempty"`
	Password string `yaml:"password,omitempty"`
}

func newBoshConfig() (BoshConfig, error) {
	usr, err := user.Current()
	if err != nil {
		return BoshConfig{}, err
	}

	absPath := filepath.Join(usr.HomeDir, ".bosh/config")

	yamlFile, err := ioutil.ReadFile(absPath)
	if err != nil {
		return BoshConfig{}, err
	}

	schema := &BoshConfig{}
	err = yaml.Unmarshal(yamlFile, schema)

	if err != nil {
		return BoshConfig{}, err
	}

	return *schema, nil
}

func findEnvironment(envs []Environment, alias string) (Environment, error) {
	for _, env := range envs {
		if env.Alias == alias {
			return env, nil
		}
	}

	return Environment{}, fmt.Errorf("No environment found that is aliased as '%v'", alias)
}

func buildDirector(alias string) (boshdir.Director, error) {
	fsConfig, err := newBoshConfig()

	env, err := findEnvironment(fsConfig.Environments, alias)
	if err != nil {
		return nil, err
	}

	config, err := boshdir.NewConfigFromURL(env.URL)
	if err != nil {
		return nil, err
	}

	config.CACert = env.CACert
	config.Client = env.Username
	config.ClientSecret = env.Password

	logger := boshlog.NewLogger(boshlog.LevelError)
	factory := boshdir.NewFactory(logger)

	return factory.New(config, boshdir.NewNoopTaskReporter(), boshdir.NewNoopFileReporter())
}
