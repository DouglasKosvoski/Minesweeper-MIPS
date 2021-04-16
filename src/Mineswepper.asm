# Aluno: Douglas Kosvoski - 1911100022
# Campo Minado em Mips Assembly
# Organizacao de Computadores 2020.2

	.data
nova_linha:		.asciz	"|\n "
posicao_fechada:	.asciz	"-"
separador:		.asciz	" | "
campo_header:		.asciz	"\n     0 1 2 3 4 5 6 7\n     ----------------\n 0 | "
campo_footer:		.asciz	"\n     ----------------\n"
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


	.text
main:
	# posicao inicial do campo
	la	a0, campo
	# numero de linhas
	la	t0, linhas
	lw	a1, (t0)
	# numero de colunas
	la	t1, colunas
	lw	a2, (t1)
	
	jal 	mostra_campo
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
    		
    		# printa o numero da linha
		mv	a0, t2
		li	a7, 1
		ecall
  		la 	a0, separador
		li 	a7, 4
    		ecall
    		bne	t2, a2, loopI_mostra_campo
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
end:
	nop
