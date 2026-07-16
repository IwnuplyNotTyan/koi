package main

import (
	"context"
	"fmt"
	"io"
	"os"

	"charm.land/fang/v2"
	"github.com/charmbracelet/log"
	glamour "github.com/iwnuplynottyan/glamoured"
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
		Example: "koi LICENSE\necho '# Hello' | koi",
		Args:    cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			var content []byte
			var err error

			stat, _ := os.Stdin.Stat()
			isPipe := (stat.Mode() & os.ModeCharDevice) == 0

			if len(args) == 0 {
				if isPipe {
					content, err = io.ReadAll(os.Stdin)
				} else {
					_ = cmd.Help()
					return
				}
			} else {
				filename := args[0]
				if filename == "-" {
					content, err = io.ReadAll(os.Stdin)
				} else {
					content, err = os.ReadFile(filename)
				}
			}

			if err != nil {
				logger.Error("~ Read error", "err", err)
				return
			}

			theme := os.Getenv("KOI_DEFAULT_THEME")
			if theme == "" {
				theme = "dark"
			}

			mosaic := true
			if mosaicEnv := os.Getenv("KOI_MOSAIC"); mosaicEnv != "" {
				mosaic = mosaicEnv != "false"
			}

			nerd := false
			if nerdEnv := os.Getenv("KOI_NERD_FONTS"); nerdEnv != "" {
				nerd = nerdEnv == "true"
			}

			badges := true
			if badgesEnv := os.Getenv("KOI_BADGES"); badgesEnv != "" {
				badges = badgesEnv == "true"
			}

			opts := []glamour.TermRendererOption{
				glamour.WithStandardStyle(theme),
				glamour.WithMosaic(mosaic),
				glamour.WithShieldsBadges(badges),
			}
			if nerd {
				opts = append(opts, glamour.WithNerdFontIcons())
			}

			r, _ := glamour.NewTermRenderer(opts...)

			render, err := r.Render(string(content))
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
