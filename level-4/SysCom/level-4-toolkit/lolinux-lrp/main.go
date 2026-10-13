package main

/*
 * Intsall go for your respected os first
 * Usage:		
 * 		Without making an executable: 
 * 					go run main.go [target_Directory]
 * 
 * 		To compile into an executable and run:
 * 					go mod init
 * 					go build -o sorter
 * 					./sorter [target_Directory]
 * 		
 */

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"sync"
)

var extensionToCategory = map[string]string{
    // Images
    ".jpg":  "image", ".jpeg": "image", ".png":  "image", ".gif":  "image",
    ".webp": "image", ".svg":  "image", ".bmp":  "image", ".ico":  "image",

    // Documents & Text
    ".pdf":  "document", ".doc":  "document", ".docx": "document", ".xls":  "document",
    ".xlsx": "document", ".ppt":  "document", ".pptx": "document", ".txt":  "document",
    ".csv":  "document", ".md":   "document", ".rtf":  "document",

    // Audio
    ".mp3":  "audio", ".wav":  "audio", ".ogg":  "audio",
    ".flac": "audio", ".aac":  "audio",

    // Video
    ".mp4":  "video", ".mkv":  "video", ".mov":  "video",
    ".avi":  "video", ".webm": "video",

    // Archives & Compressed
    ".zip": "archive", ".tar": "archive", ".gz":  "archive",
    ".rar": "archive", ".7z":  "archive",

    // Data
    ".json": "data", ".xml":  "data", ".yaml": "data",
    ".yml":  "data", ".sql":  "data",

    // Code
    ".go":   "code", ".js":   "code", ".ts":   "code", ".html": "code", ".css":  "code",
    ".py":   "code", ".c":    "code", ".h":    "code", ".cpp":  "code",
}

func moveToDir(ext string)string{
    dir,ok := extensionToCategory[ext];
    if(!ok){
        return "other";
    }
    return dir;
}

func sortFile(i os.DirEntry, oldAbsPath string, createdDirs *sync.Map, wg *sync.WaitGroup) error{
	defer wg.Done();
	
	file := i.Name();
    ext := strings.ToLower(filepath.Ext(file));//first get ext and then make it lowercase
    
    subDir := filepath.Join(oldAbsPath,moveToDir(ext));
    
    newAbsPath,err := filepath.Abs(subDir);
    if err != nil {
        fmt.Println("Error: ", err);
        return err;
    }
    
    if _,exists := createdDirs.Load(newAbsPath); !exists {
   		err = os.MkdirAll(newAbsPath,0755);//MkdirAll because mkdir will give an err if folder already exists
        if err != nil {
            fmt.Println("Error: ", err);
            return err;
        }

		createdDirs.Store(newAbsPath,true);
    }
    
    oldPath := filepath.Join(oldAbsPath,file);
    newPath := filepath.Join(newAbsPath,file);

    _, err = os.Stat(newPath);
    counter := 0;
    if err == nil{
        basePath := strings.TrimSuffix(newPath,ext);
        newNewPath := "";
        for err==nil {
            counter++;
            newNewPath = fmt.Sprintf("%s(%d)%s",basePath,counter,ext)
             _, err = os.Stat(newNewPath);
        }
        newPath = newNewPath;
    }

    err = os.Rename(oldPath,newPath);
    if err != nil {
        fmt.Println("Error: ", err);
        return err;
    }
    
    fmt.Println("Moved ",file," to ",subDir);
    return nil;
}

func SortDir(targetDir string) error {
    dir,err := os.ReadDir(targetDir);
    if err != nil {
        return err;
    }
    
    oldAbsPath,err := filepath.Abs(targetDir);
    if err != nil {
        return err;
    }

    var createdDirs sync.Map;//a makeshift cache/map of the subDirs(eg: pdf,documents etc)

    max := 50;//at max how many goroutines run at a time

    c := make(chan bool,max);
    wg := new(sync.WaitGroup);
    
    for _,i := range dir{
    	if i.IsDir(){
     		continue;
     	}
      
      	c <- true;
      	wg.Add(1);
       	go func(entry os.DirEntry){
			defer func(){<-c}();
	       	err := sortFile(entry,oldAbsPath,&createdDirs,wg);
	        if err != nil {
	        	fmt.Println("Error:",err);
	        }
        }(i)
       
    }

    wg.Wait();
    
    return nil;
}

func main(){
    if len(os.Args) < 2 {
        log.Fatal("Please enter target directory to sort");
    }
    args := os.Args[1];

    err := SortDir(args);
    if err != nil {
        log.Fatal(err);
    }
}