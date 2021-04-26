# 
# 
# for i in range(1, 8+1, 1):
# 	for j in range(1, 8+1, 1):
# 		index = i*8 + j - 8
# 		print("%3d" % index, end=" ")
# 	print()


print("\n\n")

for i in range(0, 8, 1):
    for j in range(0, 8, 1):
        index = (i*8 + j)*4
        print("%3d" % (index), end=" ")
    print()


print("\n\n")

for i in range(0, 8, 1):
    for j in range(0, 8, 1):
        index = (i*8 + j)*4
        print("%3d" % (index%32), end=" ")
    print()
print("\n\n")

for i in range(0, 8, 1):
    for j in range(0, 8, 1):
        i_j = (i*8 + j)*4
        
        print("[%d" % (i_j%32), end=" ")
        i_j += 4
        print("%d]" % (i_j%32), end=" ")
    print()

