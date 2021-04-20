# Aluno: Douglas Kosvoski - 1911100022
# Campo Minado em Mips Assembly
# Organizacao de Computadores 2020.2

	.data
msg_debug:		.asciz	"\n######### DEBUG ########\n"
msg_nova_linha:		.asciz	"|\n "
msg_icone_fechado:	.asciz	"█"
msg_icone_bandeira:	.asciz	"F"
msg_icone_bomba:	.asciz	"X"
msg_icone_separador:	.asciz	" | "
msg_campo_header:	.asciz	"\n\n\n\n\nCampo:\n     0 1 2 3 4 5 6 7\n    ------------------\n 0 | "
msg_campo_footer:	.asciz	"   ------------------\n"
msg_opcoes_menu:	.asciz	"\n 0 - sair\n 1 - abrir posicao\n 2 - posicionar/remover bandeira\n Opcao: "
msg_abrir_posicao:	.asciz	"\n Qual posicao pretende abrir?: "
msg_pega_i:		.asciz	"\n Entre com o indice da Linha: "
msg_pega_j:		.asciz	" Entre com o indice da coluna: "
msg_bandeira:		.asciz	"\n Qual bandeira deseja colocar/remover?: "

salva_S0:   	.word 	0
salva_ra:   	.word 	0
salva_ra1:	.word 	0
linhas:		.word	8
colunas:	.word	8
campo:		.word
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
				
interface:	.word
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	0 0 0 0 0 0 0 0
	
	.text
inicializa:
	la	a0, campo
	la	t0, linhas
	lw	a1, (t0)
	jal 	INSERE_BOMBA
	nop
menu:
	la	a0, campo
	la	t0, linhas
	lw	a1, (t0)
	la	t1, colunas
	lw	a2, (t1)
	mv	s0, ra
	jal	mostra_campo
	# exibe menu de escolhas
	la 	a0, msg_opcoes_menu
	li 	a7, 4
    	ecall
	# pega input da escolha do menu
	li 	a7, 5
    	ecall
   	# condicao de abrir posicao
  	li	a1, 1
  	beq	a0, a1, abrir_posicao
  	# condicao de colocar/remover bandeira
  	li	a1, 2
  	beq	a0, a1, bandeira
  	# se a opcao nao foi 1 nem 2 termina o programa
	j	end

	abrir_posicao:
		# printa mensagem
		la 	a0, msg_abrir_posicao
		li 	a7, 4
    		ecall
    		# retorna o indice da matriz
    		jal	pega_ij
    		# load campo
    		# adiciona o retorno no endereco do campo
    		# verifica qual valor tem la
    			# se tiver 9 eh game over
    			# se tiver um Flag, avisa q tem flag
    			# senao mostra o numero de bombas ao redor
    		j	menu
		
	bandeira:
		# printa mensagem
		la 	a0, msg_bandeira
		li 	a7, 4
    		ecall
    		# retorna o indice linear da matriz
		jal	pega_ij
		# load campo
		# incrementa o endereco
		# verifica se ja tem bandeira nesse lugar
			# se sim, remove a bandeira (calcula o numero de bombas ao redor e substitui o valor em alguma outra matriz
			# se nao, adiciona mais 10 em alguma matriz
		j	menu
		
	pega_ij:
    		# printa mensagem para o input do valor do i
		la 	a0, msg_pega_i
		li 	a7, 4
    		ecall
    		# pega o I
		li 	a7, 5
    		ecall
    		mv	a3, a0
    		# printa mensagem para o input do valor do j
		la 	a0, msg_pega_j
		li 	a7, 4
    		ecall
    		# pega o J
		li 	a7, 5
    		ecall
    		mv	a4, a0
    		
    		# I*n + J
    		la	t1, linhas
		lw	a1, (t1)
    		mul	a1, a3, a1
    		add	a1, a1, a4
    		li	a2, 8
    		mul	a1, a1, a2		
    		# retona o indice linear IJ da matriz em a1
		ret
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
	la 	a0, msg_campo_header
	li 	a7, 4
    	ecall
	jal	loopI_mostra_campo
	mv	ra, s0
	# printa rodape do campo
	la 	a0, msg_campo_footer
	li 	a7, 4
    	ecall
	ret
	
	printa_numero_linha:
		# printa o numero da linha
		mv	a0, t2
		li	a7, 1
		ecall
		la 	a0, msg_icone_separador
		li 	a7, 4
		ecall
    		
	loopI_mostra_campo:
		# printa o valor do vetor
		li	t3, 0
		lw	t3, (t0)
		# variavel para comparar se a celular esta fechada
		li	t4, 0
		li	t5, 10
		li	t6, 9
		beq	t4, t3, printa_posicao_fechada
		bge	t3, t5, printa_bandeira
		beq	t3, t6, printa_bomba
		lw	a0, 0(t0)
		li	a7, 1
		ecall
		
	sequencia:
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
 		la 	a0, msg_nova_linha
		li 	a7, 4
    		ecall
    		bne	t2, a2, printa_numero_linha
    		ret
    		
    	printa_bandeira:
    	    	# printa mensagem
		la 	a0, msg_icone_bandeira
		li 	a7, 4
	    	ecall
		b	sequencia
		
    	printa_posicao_fechada:
    		# printa a posicao como sendo fechada
   		la 	a0, msg_icone_fechado
		li 	a7, 4
    		ecall
		b	sequencia
		
	printa_bomba:
    		# printa o icone da bomba
   		la 	a0, msg_icone_bomba
		li 	a7, 4
    		ecall
		b	sequencia
		
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
                addi 	t6, zero, 125              # carrega constante t6 = 125
                lui  	t5, 682                    # carrega constante t5 = 2796203
                addi 	t5, t5, 1697               # 
                addi 	t5, t5, 1034               #       
                mul  	a1, a1, t6                 # a = a * 125
                rem  	a1, a1, t5                 # a = a % 2796203
                rem  	a0, a1, a0                 # a % lim
                bge  	a0, zero, EH_POSITIVO      # testa se valor eh positivo
                addi 	t4, zero, -1               # caso não 
                mul  	a0, a0, t4                 # transforma em positivo
EH_POSITIVO:    
                ret                             # retorna em a0 o valor obtido

end:
	nop