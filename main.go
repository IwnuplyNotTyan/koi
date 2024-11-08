package main

import (
	"fmt"
	"os"
	"github.com/charmbracelet/glamour"
)

func main() {
 theme := os.Getenv("THEME")
 if len(os.Args) < 2 {
	 return
 }
 filename := os.Args[1]
 content, err := os.ReadFile(filename)
 if err != nil {
	 fmt.Println("read file error")
	 return
 }
 render, err := glamour.Render(string(content), theme)
 if err != nil {
	 fmt.Println("render error")
 	 return
 }
 fmt.Print(render)
}
