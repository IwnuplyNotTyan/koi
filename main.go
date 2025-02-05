package main

import (
	"fmt"
	"os"

	"github.com/charmbracelet/glamour"
	"github.com/charmbracelet/log"
)

func main() {
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
