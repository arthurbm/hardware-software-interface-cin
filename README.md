# Hardware Software Interface (Cin-UFPE)
This is an assembly language project that includes various practical activities and exams.

# Project Structure
```
.editorconfig
.gitignore
atividades_praticas/
    ap1/
        ap1.asm
    ap2/
        ap2.asm
    q2/
        q2.asm
        questao2.asm
kernel.asm
makefile
provas/
    prova1/
        prova1_prof.asm
        prova1.asm
    prova2/
        prova2.asm
```

# Building and Running
To compile and execute an assembly file, use the make command with the file variable set to the path of the file (without the .asm extension). For example:
```bash
make file=atividades_praticas/ap1/ap1
```
This will compile the ap1.asm file in the atividades_praticas/ap1/ directory and execute the resulting binary.

Cleaning Up
To remove all generated binary files, run:
```bash
make clean
```

# Code Style
This project uses the EditorConfig to maintain a consistent coding style. The configuration is defined in the .editorconfig file.