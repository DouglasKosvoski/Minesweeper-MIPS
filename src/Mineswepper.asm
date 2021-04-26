# Aluno: Douglas Kosvoski - 1911100022
# Campo Minado em Mips Assembly
# Organizacao de Computadores 2020.2

	.data
campo:			.space 256
interface:		.space 256
linhas:			.word	8
colunas:		.word	8
msg_nova_linha:		.asciz	"|\n "
msg_icone_fechado:	.asciz	"█"
msg_icone_bandeira:	.asciz	"F"
msg_icone_bomba:	.asciz	"X"
msg_icone_separador:	.asciz	" | "
msg_campo_header:	.asciz	"\n Campo:\n     0 1 2 3 4 5 6 7\n    ------------------\n 0 | "
msg_campo_footer:	.asciz	"   ------------------\n"
msg_opcoes_menu:	.asciz	"\n 0 - sair\n 1 - abrir posicao\n 2 - posicionar/remover bandeira\n Opcao: "
msg_abrir_posicao:	.asciz	"\n Qual posicao pretende abrir?: "
msg_pega_i:		.asciz	"\n Entre com o valor do I: "
msg_pega_j:		.asciz	" Entre com o valor do J: "
msg_erro_pega_input:	.asciz	"\n\n ########################################\n #### Numero da posicao invalida !!! ####\n ########################################\n"
msg_erro_bandeira:	.asciz	"\n\n ########################################\n #### Bandeira ja posicionada    !!! ####\n ########################################\n"
msg_erro_abrir:		.asciz	"\n ########################################\n     Tem bandeira. Jogada invalida !!!      \n ########################################\n"
msg_removendo_bandeira:	.asciz	"\n ########################################\n ####   Removendo bandeira !!!       ####\n ########################################\n"
msg_game_over:		.asciz	"\n ########################################\n ####   Explodido... Acabou !!!      ####\n ########################################\n"
msg_bandeira:		.asciz	"\n Qual bandeira deseja colocar/remover?: "
##### Labels Professor ##########
salva_S0:   		.word 	0
salva_ra:   		.word 	0
salva_ra1:		.word 	0
#################################

	.text
main:
	la	a0, campo
	addi	a1, zero, 8
	jal 	INSERE_BOMBA

menu:
	la	a0, campo
	addi	a1, zero, 8
	addi	a2, zero, 8
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
    		la	a0, campo

    		# percorre o campo
    		add	a0, a0, a1
    		# carrega o valor no campo
    		lw	t0, (a0)
    		# valor da bomba
    		li	t1, 9
    		# se o valor da posicao no campo for 9 eh fim de jogo
    		beq	t0, t1, game_over
    		# se o valor da posicao no campo for maior do q 9 eh pq tem uma bandeira
    		bgt	t0, t1, nao_pode_abrir
    		
        calcula_bombas:
		# salva o numero de bombas adjacentes no campo
        	addi	t0, t0, 3
        	sw	t0, (a0)
		# abre a posicao na matriz interface
           	la	a2, interface
           	add	a2, a2, a1
           	lw	t0, (a2)
           	addi	t0, t0, 1
		sw	t0, (a2)
    		j	menu
    		
    	nao_pode_abrir:
    		# printa mensagem
		la 	a0, msg_erro_abrir
		li 	a7, 4
    		ecall
    		j	menu
	
	game_over:
		# printa mensagem
		la 	a0, msg_game_over
		li 	a7, 4
    		ecall
    		la	a0, campo
    		la	a1, interface
		# pega o tamanho (lado * lado)
    		la	a2, linhas
    		lw	a2, (a2)
		mul	a2, a2, a2
    		# variavel de controle
		li	t0, 0
		li	t1, 9
		abre_bombas:
			# pega o valor no campo
			lw	t2, (a0)
			# se o valor no campo for uma bomba ou uma bandeira
			bge	t2, t1, abre
			j	asd
			abre:
				# pega o valor na interface
				li	t3, 1
				sw	t3, (a1)
			asd:
				# caminho pelo campo
				addi	a0, a0, 4
				# caminha pela interface
				addi	a1, a1, 4
				# incrementa a variavel de controle
				addi	t0, t0, 1
				bne	t0, a2, abre_bombas
		la	a0, campo
		addi	a1, zero, 8
		addi	a2, zero, 8
		mv	s0, ra
		jal	mostra_campo
		j	end
		
	bandeira:
		# printa mensagem
		la 	a0, msg_bandeira
		li 	a7, 4
    		ecall
    		
    		# retorna o indice linear da matriz
		jal	pega_ij
		
		# posiciona a bandeira na matriz campo
		la	a0, campo
		mv	a3, a1
		add	a0, a0, a1
		lw	a1, 0(a0)
		li	a2, 9
		
		# se ja tem bandeira
		bgt	a1, a2, remove_bandeira
		
		# se nao tem bandeira
		addi	a1, a1, 10
		sw	a1, 0(a0)
		la	a0, interface
		add	a0, a0, a3
		lw	a1, 0(a0)
		addi	a1, a1, 1
		sw	a1, 0(a0)
		j	menu

	erro_input:
		# avisa que o numero inserido eh invalido
		la 	a0, msg_erro_pega_input
		li 	a7, 4
    		ecall
    		j	menu

	remove_bandeira:
		# avisa que ja existe bandeira na posicao
		la 	a0, msg_erro_bandeira
		li 	a7, 4
    		ecall
    		
    		# avisa que a bandeira vai ser removida
		la 	a0, msg_removendo_bandeira
		li 	a7, 4
    		ecall
    		
    		# remove a bandeira da matriz campo
		la	a0, campo
		add	a0, a0, a3
		lw	a1, 0(a0)
		addi	a1, a1, -10
		sw	a1, 0(a0)
		
		# fecha a posicao na matriz interface
		la	a0, interface
		add	a0, a0, a3
		lw	a1, 0(a0)
		addi	a1, a1, -1
		sw	a1, 0(a0)
    		j	menu
    		
	pega_ij:
    		# printa mensagem para o input do valor do i
		la 	a0, msg_pega_i
		li 	a7, 4
    		ecall
    		# pega o I
		li 	a7, 5
    		ecall
    		# verifica se o input eh maior do 0 e menor do que 8
    		li	a1, 0
    		blt	a0, a1, erro_input
    		li	a1, 7
    		bgt	a0, a1, erro_input
    		mv	a3, a0
    		# printa mensagem para o input do valor do j
		la 	a0, msg_pega_j
		li 	a7, 4
    		ecall
    		# pega o J
		li 	a7, 5
    		ecall
    		# verifica se o input eh maior do 0 e menor do que 8
    		li	a1, 0
    		blt	a0, a1, erro_input
    		li	a1, 7
    		bgt	a0, a1, erro_input
    		mv	a4, a0
    		
    		# I*n + J
    		la	t1, linhas
		lw	a1, (t1)
    		mul	a1, a3, a1
    		add	a1, a1, a4
    		li	a2, 4
    		mul	a1, a1, a2
    		mv	a2, a3
    		mv	a3, a4
    		# retona o indice linear IJ da matriz em a1
    		# retorna o I no a2
    		# retorna o J no a3
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
	la	a3, interface
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
		lw	s1, (a3)
		li	t4, 0
		# se a posicao estiver fechada na matriz interface, printa posicao fechada
		beq	s1, t4, printa_posicao_fechada
		# se nao printa outro caracter/valor
		li	t5, 10
		li	t6, 9
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
		# caminha pela interface
		addi	a3, a3, 4
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
		
#################### FUNCOES DO PROFESSOR ####################
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
