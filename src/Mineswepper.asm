# Aluno: Douglas Kosvoski - 1911100022
# Campo Minado em Mips Assembly
# Organizacao de Computadores 2020.2

	.data
nova_linha:		.asciz	"|\n "
posicao_fechada:	.asciz	"-"
separador:		.asciz	" | "
campo_header:		.asciz	"\nCampo:\n     0 1 2 3 4 5 6 7\n    ------------------\n 0 | "
campo_footer:		.asciz	"   ------------------\n"
campo:			.word  	0 0 0 0 0 0 0 0
				0 0 0 0 0 0 0 0
				0 0 0 0 0 0 0 0
				0 0 0 0 0 0 0 0
				0 0 0 0 0 0 0 0
				0 0 0 0 0 0 0 0
				0 0 0 0 0 0 0 0
				0 0 0 0 0 0 0 0
linhas:			.word	8
colunas:		.word	8
salva_S0:               .word   0
salva_ra:               .word   0
salva_ra1:              .word   0


	.text
main:
	la	a0, campo
	la	t0, linhas
	lw	a1, (t0)
	la	t1, colunas
	lw	a2, (t1)
	jal	mostra_campo
	
	la	a0, campo
	la	t0, linhas
	lw	a1, (t0)
	la	t1, colunas
	lw	a2, (t1)
	jal 	INSERE_BOMBA

	la	a0, campo
	la	t0, linhas
	lw	a1, (t0)
	la	t1, colunas
	lw	a2, (t1)
	jal	mostra_campo
	j	end

mostra_campo:
	# recebe o endereco inicial do campo em a0
	# recebe o numero de linhas em a1
	# recebe o numero de colunas em a2
	
	# controle do campo
	mv	t0, a0
	# variavel I
	li	t1, 0
	# variavel J
	li	t2, 0
	mv	s0, ra
	# printa cabecalho do campo
	la 	a0, campo_header
	li 	a7, 4
    	ecall
	jal	loopI_mostra_campo
	mv	ra, s0
	# printa rodape do campo
	la 	a0, campo_footer
	li 	a7, 4
    	ecall
	ret
	printa_numero_linha:
    		# printa o numero da linha
		mv	a0, t2
		li	a7, 1
		ecall
  		la 	a0, separador
		li 	a7, 4
    		ecall
    		
	loopI_mostra_campo:
		# printa o valor do vetor
		li	t3, 0
		lw	t3, (t0)
		beq	t4, t3, printa_posicao_fechada
		lw	a0, 0(t0)
		li	a7, 1
		ecall
		# printa um espaco em branco
    		li      a0, 32
    		li      a7, 11  
    		ecall
    		# caminha pelo campo
    		addi	t0, t0, 4
    		# incrementa variavel I
    		addi	t1, t1, 1
		bne	t1, a1, loopI_mostra_campo
		beq	t1, a1, loopJ_mostra_campo

    		ret
		
	loopJ_mostra_campo:
		# printa um espaco em branco
    		li      a0, 32
    		li      a7, 11
    		ecall
    		# reseta variavel I
    		li	t1, 0		
    		# incrementa variavel J
    		addi	t2, t2, 1
    		# printa nova linha
   		la 	a0, nova_linha
		li 	a7, 4
    		ecall
    		bne	t2, a2, printa_numero_linha
    		ret
    		
    	printa_posicao_fechada:
    		# printa a posicao como sendo fechada
   		la 	a0, posicao_fechada
		li 	a7, 4
    		ecall
		# printa um espaco em branco
    		li      a0, 32
    		li      a7, 11  
    		ecall
    		# caminha pelo campo
    		addi	t0, t0, 4
    		# incrementa variavel I
    		addi	t1, t1, 1
    		
		beq	t1, a1, loopJ_mostra_campo
		bne	t1, a1, loopI_mostra_campo
		ret
		
INSERE_BOMBA:
                la      t0, salva_S0
                sw      s0, 0 (t0)              # salva conteudo de s0 na memoria
                la      t0, salva_ra
                sw      ra, 0 (t0)              # salva conteudo de ra na memoria
                add     t0, zero, a0            # salva a0 em t0 - endereço da matriz campo
                add     t1, zero, a1            # salva a1 em t1 - quantidade de linhas 

QTD_BOMBAS:
                addi    t2, zero, 15            # seta para 15 bombas   
                add     t3, zero, zero  	# inicia contador de bombas com 0
                addi    a7, zero, 30            # ecall 30 pega o tempo do sistema em milisegundos (usado como semente)
                ecall                           
                add     a1, zero, a0            # coloca a semente em a1
INICIO_LACO:
                beq     t2, t3, FIM_LACO
                add     a0, zero, t1            # carrega limite para % (resto da divisão)
                jal     PSEUDO_RAND
                add     t4, zero, a0            # pega linha sorteada e coloca em t4
                add     a0, zero, t1            # carrega limite para % (resto da divisão)
                jal     PSEUDO_RAND
                add     t5, zero, a0            # pega coluna sorteada e coloca em t5
LE_POSICAO:     
                mul     t4, t4, t1
                add     t4, t4, t5              # calcula (L * tam) + C
                add     t4, t4, t4              # multiplica por 2
                add     t4, t4, t4              # multiplica por 4
                add     t4, t4, t0              # calcula Base + deslocamento
                lw      t5, 0(t4)               # Le posicao de memoria LxC
VERIFICA_BOMBA:         
                addi    t6, zero, 9             # se posição sorteada já possui bomba
                beq     t5, t6, PULA_ATRIB      # pula atribuição 
                sw      t6, 0(t4)               # senão coloca 9 (bomba) na posição
                addi    t3, t3, 1               # incrementa quantidade de bombas sorteadas
PULA_ATRIB:
                j       INICIO_LACO
FIM_LACO:                                       # recupera registradores salvos
                la      t0, salva_S0
                lw      s0, 0(t0)               # recupera conteudo de s0 da memória
                la      t0, salva_ra
                lw      ra, 0(t0)               # recupera conteudo de ra da memória            
                jr      ra                      # retorna para funcao que fez a chamada
PSEUDO_RAND:
                addi t6, zero, 125              # carrega constante t6 = 125
                lui  t5, 682                    # carrega constante t5 = 2796203
                addi t5, t5, 1697               # 
                addi t5, t5, 1034               #       
                mul  a1, a1, t6                 # a = a * 125
                rem  a1, a1, t5                 # a = a % 2796203
                rem  a0, a1, a0                 # a % lim
                bge  a0, zero, EH_POSITIVO      # testa se valor eh positivo
                addi t4, zero, -1               # caso não 
                mul  a0, a0, t4                 # transforma em positivo
EH_POSITIVO:    
                ret                             # retorna em a0 o valor obtido

		
end:
	nop
