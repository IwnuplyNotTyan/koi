package main

import (
	"context"
	"fmt"
	"os"

	"charm.land/fang/v2"
	"github.com/charmbracelet/glamour"
	"github.com/charmbracelet/log"
	"github.com/spf13/cobra"
)

var version = "dev"
var commit = ""

func main() {
	logger := log.New(os.Stderr)

	cmd := &cobra.Command{
		Use:     "koi [file]",
		Short:   "Koi - Simple .md reader",
		Long:    "Simple .md reader. Made with ♡",
		Example: `koi LICENSE`,
		Args:    cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			if len(args) == 0 {
				_ = cmd.Help()
				return
			}

			filename := args[0]
			
			content, err := os.ReadFile(filename)
			if err != nil {
				logger.Error("~ Read file error", "err", err)
				return
			}

			theme := os.Getenv("THEME")
			if theme == "" {
				theme = "dark"
			}

			render, err := glamour.Render(string(content), theme)
			if err != nil {
				logger.Error("~ Render error", "err", err)
				return
			}
			fmt.Print(render)
		},
	}

	opts := []fang.Option{fang.WithVersion(version)}
	if commit != "" {
		opts = append(opts, fang.WithCommit(commit))
	}

	if err := fang.Execute(context.Background(), cmd, opts...); err != nil {
		log.Error(err)
		os.Exit(1)
	}
}
