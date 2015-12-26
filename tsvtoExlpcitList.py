import sys,re

def main(args):
    print(args[0])
    with open(args[0]) as f:
        aluCode = r'\d{6}'
        refline = []
        for line in f.readlines():
            bits = line.split('\t')
            if bits[0] == "Instruction":
                refline = bits
            else:
                for i in range(len(bits)):
                    # bits is alusrc
                    if (re.match(r'\d{6}', bits[i])):
                        print(bits[i]),
                    else:
                        try:
                            zoro = int(bits[i])
                            if (zoro):
                                print(refline[i]),
                        except ValueError:
                            print(bits[i]),



if __name__ == "__main__":
    main(sys.argv[1:])
