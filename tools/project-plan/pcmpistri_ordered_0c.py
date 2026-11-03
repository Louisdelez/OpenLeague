"""PCMPISTRI imm0C: unsigned bytes, equal ordered, positive, least index.

Comparisons crossing the end of the 128bit vector are truncated, permitting
partial candidates. An in-vector invalid haystack byte still fails a valid
pattern byte. The original search body checks candidates across later vectors.
"""
ARITHMETIC_FLAGS=0x8d5
def compare(left,right,flags):
    if len(left)!=16 or len(right)!=16:raise ValueError('exact16byte vectors required')
    a=left.find(b'\0');b=right.find(b'\0')
    if a<0:a=16
    if b<0:b=16
    bits=0
    for start in range(16):
        match=True
        for i in range(16-start):
            if i>=a:continue
            j=start+i
            if j>=b or left[i]!=right[j]:match=False;break
        if match:bits|=1<<start
    index=(bits&-bits).bit_length()-1 if bits else 16
    arithmetic=int(bits!=0)|(int(b<16)<<6)|(int(a<16)<<7)|((bits&1)<<11)
    return {'ecx':index,'eflags':(flags&~ARITHMETIC_FLAGS)|arithmetic,'result_bits':bits}
