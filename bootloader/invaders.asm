org 7c00h

;; CONSTANTS =====================================
SCREEN_WIDTH        equ 320     ; Width in pixels
SCREEN_HEIGHT       equ 200     ; Height in pixels
VIDEO_MEMORY        equ 0A000h
TIMER               equ 046Ch   ; # of timer ticks since midnight
BARRIERXY           equ 1655h
BARRIERX            equ 16h
BARRIERY            equ 55h
PLAYERY             equ 93
SPRITE_HEIGHT       equ 4
SPRITE_WIDTH        equ 8       ; Width in bits/data pixels
SPRITE_WIDTH_PIXELS equ 16      ; Width in screen pixels

; Colors
ALIEN_COLOR         equ 02h   ; Green
PLAYER_COLOR        equ 07h   ; Gray
BARRIER_COLOR       equ 27h   ; Red
PLAYER_SHOT_COLOR   equ 0Bh   ; Cyan
ALIEN_SHOT_COLOR    equ 0Eh   ; Yellow


;; SETUP ===================================

;; set up video mode - VGA mode 13h, 320X200, 256. Each Pixel have (1Byte/8b)pp
;; 320 pixels * 200 rows = 64,000 bytes
;; To draw a pixel at a specific position (x, y) ===> offset = y * 320 + x
;; segment address 0xA000

mov ax, 0013h
int 10h

;; set up video mem
push VIDEO_MEMORY
pop es

game_loop:
  xor ax, ax   ;; clear screen to black
  xor di, di
  mov cx , SCREEN_HEIGHT * SCREEN_WIDTH
  rep stosb    ;; mov [ES:DI] , al : cx no. times


  delay_timer:
    mov ax, [TIMER]
    add ax, 18
    .wait:
      cmp [TIMER], ax
      jl .wait

game_over:
  cli
  hlt

;; CODE SEGMENT DATA ========================
sprite_bitmaps:
    db 10011001b    ; Alien 1 bitmap
    db 01011010b
    db 00111100b
    db 01000010b

    db 00011000b    ; Alien 2 bitmap
    db 01011010b
    db 10111101b
    db 00100100b

    db 00011000b    ; Player ship bitmap
    db 00111100b
    db 00100100b
    db 01100110b

    db 00111100b    ; Barrier bitmap
    db 01111110b
    db 11100111b
    db 11100111b

    ;; Initial variable values
    dw 0FFFFh       ; Alien array
    dw 0FFFFh
    db 70           ; PlayerX
    ;; times 8 db 0 ; Shots array
    dw 230Ah        ; alienY & alien X | 10 = Y, 35 = X
    db 20h          ; # of aliens = 32 TODO: Remove & check if alienArr = 0, 
                    ;   This is probably not needed, can save some bytes
    db 0FBh         ; Direction -5
    dw 18           ; Move timer
    db 1            ; Change alien - toggle between 1 & -1

;; **INT 1Ah, AH=00h** to read the current tick count (18 ticks, each tick being around 55 ms)


times 510 - ($ - $$) db 0
dw 0AA55h       ;; boot signature


