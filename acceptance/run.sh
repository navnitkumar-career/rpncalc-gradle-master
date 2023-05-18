#! /bin/bash

cp ../app/build/libs/app.jar ./app.jar

falhou=0
for entrada in *_entrada.txt; do
  teste=$(echo ${entrada} | sed -e s/_entrada.txt//)
  cat "${teste}_saida.txt" | tr -d '\r' > saida_esperada.txt
  linhas=$(wc -l saida_esperada.txt | cut -f 1 -d " ")
  echo -n "Rodando o teste de aceitação ${teste}.........."
  java -jar app.jar < ${entrada} | tr -d '\r' | tail -n ${linhas} -- > saida_atual.txt
  diff -y --strip-trailing-cr saida_esperada.txt saida_atual.txt > diferenca.txt
  if [ $? -ne 0 ]; then
    falhou=1
    echo "FALHOU"
    echo "Erro no teste ${teste}:"
    echo -n "             >>>>>> ESPERADO <<<<<<                           "
    echo -n "              >>>>>> OBTIDO <<<<<<                            "
    echo ""
    cat diferenca.txt
  else
    echo "PASSOU"
  fi
done

rm saida_atual.txt saida_esperada.txt diferenca.txt

exit ${falhou}
