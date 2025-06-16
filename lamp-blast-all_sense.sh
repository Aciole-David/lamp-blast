
for i in `ls *.fna`; do

cat $i | pv -l -s $(wc -l < $i) \
| sed -ze 's/\n\n/\n/g' -ze 's/\n/@/g' | rev | sed 's/@//' | rev | sed -ze "s|@>|\n|g" -e 's|>||g' > a.a;

names=`sed 's/^\([^–]*-[^–]*\)-.*/\1/' a.a | sort -u`

#printf "\n$names\n\n\n"



#echo "$headr"

titl=$(for i in $names; do 
echo -n "$i\n"
done)
f3dt=$(for i in $names; do aa=`grep -i "${i}.*-F3" a.a`
if [ -z "$aa" ]
then echo "NN"
else echo "$i $aa"  | sed 's/.*@//g'
fi; done)
f2dt=$(for i in $names; do aa=`grep -i "${i}.*-F2" a.a`
if [ -z "$aa" ]
then echo "NN"
else echo "$i $aa"  | sed 's/.*@//g'
fi; done)
f1dt=$(for i in $names; do aa=`grep -i "${i}.*-F1" a.a`
if [ -z "$aa" ]
then echo "NN"
else echo "$i $aa"  | sed 's/.*@//g'
fi; done)
b3dt=$(for i in $names; do aa=`grep -i "${i}.*-B3" a.a`
if [ -z "$aa" ]
then echo "NN"
else echo "$i $aa"  | sed 's/.*@//g'
fi; done)
b2dt=$(for i in $names; do aa=`grep -i "${i}.*-B2" a.a`
if [ -z "$aa" ]
then echo "NN"
else echo "$i $aa"  | sed 's/.*@//g'
fi; done)
b1dt=$(for i in $names; do aa=`grep -i "${i}.*-B1" a.a`
if [ -z "$aa" ]
then echo "NN"
else echo "$i $aa"  | sed 's/.*@//g'
fi; done)
lfdt=$(for i in $names; do aa=`grep -i "${i}.*-LF" a.a`
if [ -z "$aa" ]
then echo "LF"
else echo "$i $aa"  | sed 's/.*@//g'
fi; done)
lbdt=$(for i in $names; do aa=`grep -i "${i}.*-LB" a.a`
if [ -z "$aa" ]
then echo "LB"
else echo "$i $aa"  | sed 's/.*@//g'
fi; done)

full=$(paste \
<(printf "$titl") \
<(printf "$f3dt") \
<(printf "$f2dt") \
<(printf "$lfdt") \
<(printf "$f1dt") \
<(printf "$b1dt") \
<(printf "$lbdt") \
<(printf "$b2dt") \
<(printf "$b3dt") ) 

headr=$(printf "set\tF3\tF2\tLF\tF1\tB1\tLB\tB2\tB3\n")

printf "$headr\n$full" > $i.csv

done

wait

for k in `ls *.csv.fasta`; do
#remove header 
sed -i '1d' $k

#add ">" as first char
sed -i 's/^/>/' $k

#replace first tab by new line
sed -i 's/\t/\n/' $k

#replace remaining tab by NN
sed -i 's/\t/NN/g' $k

#replace null loops by NN
#LF string is reversed
sed -i 's/NNLBNN/NN/' $k
sed -i 's/NNFLNN/NN/' $k;


done

rename 's/.csv.fasta/.fasta/g' *.csv.fasta
rm a.a
