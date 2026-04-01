	
; music/replayer.s
; Original Re-player by Grauw (https://hg.sr.ht/~grauw/re-play)


; ------------------------------------------------------------------
; Instalar hook em H.KEYI (FD9Ah)
; ------------------------------------------------------------------
RePlayer_HookInstall:
    di
    ld  a,0C3h
    ld  (0FD9Ah),a      ; HKEYI hook (V-Blank interruption)

    ld  hl,RePlayer_IRQ_Hook
    ld  (0FD9Ah+1),hl
    ei
    ret

; ------------------------------------------------------------------
; Replayer IRQ Hook Routine
; ------------------------------------------------------------------
RePlayer_IRQ_Hook:
    ; ld      a,(0007h)     ; Change color Border to see CPU consume of music routine
    ; ld      c,a
    ; inc     c
    ; push    bc            ; Saves VDP Register Port to use it again
    
    ; ld	    b,15
	; out	    (c),b		
	; ld	    b,80h +7			
	; out	    (c),b               
  
    call    RePlayer_Tick_entry 
    
	ld	    a,(Seg_P8000_SW_Mirror)     ; Restore Megarom bank
	ld	    (7000h),a                   ;

    ; pop       bc           ; Restore VDP Register Port 
    ; ld	    b,3          ; Restore Border color
	; out	    (c),b		
	; ld	    b,80h +7			
	; out	    (c),b               

    xor     A           ; Set P Flag so BIOS Interruption don't execute all IO routines and return immediately to main program
  	ret

; ------------------------------------------------------------------
; Replayer Init
; ------------------------------------------------------------------
RePlayer_Init:
    di

    ld  bc,0
    ld  (Main_currentTrack),bc

    ld a,MEGAROM_PAGE_REPLAYER_0    ; First bank of sound data
	ld (RePlayer_currentBank),a	
	ld (7000h),a

	ld a,(SoundData)
	call RePlayer_Detect_entry
    call RePlayer_Stop
    call RePlayer_HookInstall 

    ld a,(Seg_P8000_SW_Mirror)      ; Restore Megarom bank
    ld   (Seg_P8000_SW),a           ;
    ei
    ret

; ------------------------------------------------------------------
; Play music track (A=Track)
; ------------------------------------------------------------------
RePlayer_PlayTrack:
    di
    ld b,0
    ld c,a
    ld (Main_currentTrack),bc
    ld a,(RePlayer_currentBank)
    ld hl,SoundData +1

    call RePlayer_Play_entry

    ld  a,(Seg_P8000_SW_Mirror)     ; Restore Megarom bank
    ld  (Seg_P8000_SW),a
    ei
    ret

; ------------------------------------------------------------------
; Stop music track
; ------------------------------------------------------------------
RePlayer_Stop:
    call RePlayer_Stop_entry
    ld a,(Seg_P8000_SW_Mirror)      ; Restore Megarom bank
    ld  (Seg_P8000_SW),a
    ret

; ------------------------------------------------------------------
; Pause / Resume music track
; ------------------------------------------------------------------
RePlayer_TogglePause:
    call RePlayer_TogglePause_entry
    ld a,(Seg_P8000_SW_Mirror)      ; Restore Megarom bank
    ld  (Seg_P8000_SW),a
    ret

