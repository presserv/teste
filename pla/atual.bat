@echo off
@c:
@f:
@cd \vip4
@echo Fazendo copia dos executaveis anteriores
@copy adpbig.exe adpold.exe /y
@echo Atualizando programa
@arj e c:\atual\adpbp -y
@echo Programa atualizado