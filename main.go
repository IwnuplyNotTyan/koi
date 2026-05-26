package main

import (
	"fmt"
	"os"
	"context"

	"github.com/charmbracelet/glamour"
	"github.com/charmbracelet/log"	
        "charm.land/fang/v2"
        "github.com/spf13/cobra"

)


var version = "dev"
var commit = ""

func main() {
	cmd := &cobra.Command{
		Use:   "Koi",
		Short: "Koi - Simple .md reader",
		Long:  "Simple .md reader. Made with ♡",
	}

	
	opts := []fang.Option{fang.WithVersion(version)}
	if commit != "" {
		opts = append(opts, fang.WithCommit(commit))
	}
	if err := fang.Execute(context.Background(), cmd, opts...); err != nil {
		log.Error(err)
	}

	logger := log.New(os.Stderr)
	theme := os.Getenv("THEME")
	if theme == "" {
		theme = "dark"
	}
	if len(os.Args) < 2 {
		return
	}
	filename := os.Args[1]
	content, err := os.ReadFile(filename)
	if err != nil {
		logger.Error("~ Read file error")
		return
	}
	render, err := glamour.Render(string(content), theme)
	if err != nil {
		logger.Error("~ Render error")
		return
	}
	fmt.Print(render)
}
