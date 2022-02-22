data segment
a dw 4500h
b dw 4500h
ancien_ip dw ?
ancien_cs dw ?
txt0 db 'TP 1$'
txt1 db 'Taper sur une touche pour quitter:$'
txt2 db 'Appuyer sur une touche pour effectuer l''operation d''addition $'
txt3 db 'ARCHI 2$'
txt4 db 'OPERATION EFFECTUEE SANS ERREUR D''OVERFLOW  $'
txt5 db 'DEROUTEMENT DE L''INTERUPTION OUVERFLOW$'
txt6 db 'LE PROCESSEUR SIGNALE UN ETAT D''OUVERFLOW,Appuyer sur une touche pour continuer$'
txt7 db 'OPERATION DE RESTORATION DU VECTEUR 4 EST TERMINEE$'

data ends

ma_pile segment stack
dw 128 dup(?)
tos label word
ma_pile ends

mon_code segment
assume cs:mon_code, ds:data,ss:ma_pile

effacer proc;effacer l'ecran
mov ax,3
int 10h
ret
effacer endp


car proc near   ; pour lire un caractère a partir du clavier
mov ah,1h
int 21h
ret
car endp


sauvgarde proc  ; procedure de sauvegarde de l'ancienne routine
mov ax,data
mov ds,ax
mov al,4h
mov ah,35h
int 21h
mov ancien_ip,bx
mov ancien_cs,es
ret
sauvgarde endp

install proc ;procedure d'installation de la nouvelle routine 
mov ax,mon_code
mov ds,ax
mov dx,offset overflow
mov al,4h
mov ah,25h
int 21h
ret
install endp

overflow:   ;nouvelle routine 
mov ax,data
mov ds,ax
mov dl,0   
mov dh,12   
mov bh,0
mov ah,2                                       
int 10h
call affiche_6
call car
iret

sum proc;procedure qui calcule la somme de a et b
mov ax,a
mov bx,b
add ax,bx
ret
sum endp

restore proc ;procedure de restoration 
mov ax,ancien_cs
mov ds,ax
mov dx,ancien_ip
mov al,4h
mov ah,25h
int 21h 
ret
restore endp
affiche_0 proc ;Pour afficher tp1
mov ax,data
mov ds,ax
mov dl,30;numero de la colonne 
mov dh,1 ;numero de la ligne 
mov bh,0
mov ah,2
int 10h 
mov dx,offset txt0
mov ah,9
int 21h
ret
affiche_0 endp
affiche_1 proc 
mov ax,data
mov ds,ax
mov dl,40  
mov dh,21  
mov bh,0
mov ah,2
int 10h 
mov dx,offset txt1
mov ah,9
int 21h
call car
ret
affiche_1 endp
affiche_2 proc
mov ax,data
mov ds,ax
mov dl,0
mov dh,4
mov bh,0
mov ah,2
int 10h
mov dx,offset txt2
mov ah,9
int 21h
call car
ret
affiche_2 endp
affiche_3 proc 
mov ax,data
mov ds,ax
mov dl,70
mov dh,1 
mov bh,0
mov ah,2
int 10h 
mov dx,offset txt3
mov ah,9
int 21h
ret
affiche_3 endp
affiche_4 proc 
mov ax,data
mov ds,ax  
mov dl,0   
mov dh,12   
mov bh,0
mov ah,2                                       
int 10h
mov dx,offset txt4
mov ah,9
int 21h
call car
ret
affiche_4 endp
affiche_5 proc ;
mov ax,data
mov ds,ax
mov dl,0 
mov dh,12 
mov bh,0
mov ah,2
int 10h
mov dx,offset txt5
mov ah,9
int 21h

ret
affiche_5 endp
affiche_6 proc 

mov ax,data 
mov ds,ax
mov dx,offset txt6
mov ah,9
int 21h
ret
affiche_6 endp
affiche_7 proc ;
mov ax,data
mov ds,ax
mov dl,0 
mov dh,16 
mov bh,0
mov ah,2
int 10h 
mov dx,offset txt7
mov ah,9
int 21h
ret
affiche_7 endp

deb :  ;le programme principal 
call effacer
mov ax,data
mov ds,ax
mov bx,ma_pile
mov ss,bx
call affiche_3
call affiche_0
call affiche_2

call sauvgarde

call sum
jno corr
call affiche_5
call install
into
call affiche_7
call restore
mov ax,4C00H
int 21h
corr : 
call affiche_4
call affiche_1
mov ax,4C00H
int 21h
mon_code ends
end deb

