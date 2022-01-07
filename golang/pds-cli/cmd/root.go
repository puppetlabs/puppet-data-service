/*
Copyright © 2021 NAME HERE <EMAIL ADDRESS>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package cmd

import (
	"fmt"
	"os"
	"strings"

	client "github.com/puppetlabs/puppet-data-service/golang/pkg/pds-go-client"

	"github.com/spf13/cobra"
	"github.com/spf13/pflag"

	"github.com/spf13/viper"
)

var (
	cfgFile string
	baseuri string
	token string
	pdsClient *client.ClientWithResponses
	envPrefix string = "PDS"
)


// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "pds-cli",
	Short: "Interact with Puppet Data Service from the command line",
	Version: "0.1",
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		pdsClient = createPDSClient(baseuri, token)
	
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	cobra.CheckErr(rootCmd.Execute())
}

func init() {
	cobra.OnInitialize(initConfig)

	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/pds-client.yaml)")
	rootCmd.PersistentFlags().StringVarP(&baseuri, "baseuri", "b", "", "Base URI for the PDS API")

	rootCmd.PersistentFlags().StringVarP(&token, "token", "t", "", "API token")

	viper.BindPFlag("baseuri", rootCmd.PersistentFlags().Lookup("baseuri"))
	viper.BindPFlag("token", rootCmd.PersistentFlags().Lookup("token"))

	rootCmd.MarkPersistentFlagRequired("baseuri")
	rootCmd.MarkPersistentFlagRequired("token")

	// baseuri = viper.GetString("baseuri")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {


	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := os.UserHomeDir()
		cobra.CheckErr(err)

		// Search config in home directory with name ".pds-cli" (without extension).
		viper.AddConfigPath(home)
		viper.AddConfigPath("/etc/puppetlabs/pds-server")
		viper.AddConfigPath(".")
		viper.SetConfigType("yaml")
		viper.SetConfigName("pds-client")
		viper.SetEnvPrefix(envPrefix)
	}

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		fmt.Fprintln(os.Stderr, "Using config file:", viper.ConfigFileUsed())
	}

	// Bind the current command's flags to viper
	bindFlags(rootCmd /* viper */)

}

// Bind each cobra flag to its associated viper configuration (config file and environment variable)
func bindFlags(cmd *cobra.Command, /*v *viper.Viper*/) {
	cmd.Flags().VisitAll(func(f *pflag.Flag) {
		// Environment variables can't have dashes in them, so bind them to their equivalent
		// keys with underscores, e.g. --favorite-color to STING_FAVORITE_COLOR
		if strings.Contains(f.Name, "-") {
			envVarSuffix := strings.ToUpper(strings.ReplaceAll(f.Name, "-", "_"))
			viper.BindEnv(f.Name, fmt.Sprintf("%s_%s", envPrefix, envVarSuffix))
		}

		// Apply the viper config value to the flag when the flag is not set and viper has a value
		if !f.Changed && viper.IsSet(f.Name) {
			val := viper.Get(f.Name)
			cmd.Flags().Set(f.Name, fmt.Sprintf("%v", val))
		}
	})
}
