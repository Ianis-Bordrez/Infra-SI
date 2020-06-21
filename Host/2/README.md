# Exploration de l'OS et du matériel

## Sujet 2 : Débugger et désassembler des programmes compilés

### Hello World

Pour commencer j'ai créé un programme qui affiche "Hello World"
```cpp
#include <iostream>

int main() {
	std::cout << "Hello World";
	return 0;
}
```

Une fois compilé, j'ai pu le désassembler via le logiciel Ghidra.
En appuyant sur la touche "S", on peut rechercher une chaine de caractère, j'ai donc cherché "Hello World". Ghidra a trouvé la chaine de caractère et nous montre qu'elle est stockée dans "ds".

### Winrar crack

Pour crack winrar, j'ai d'abord cherché la chaine de caractère "evaluation". Une fois la chaine trouvée, je suis allé dans la fonction où était appelée la chaine de caractère, et j'ai modifié la condition qui était 2 lignes plus haut en changeant "JNZ" par "JZ". Une fois fait, il me restait plus qu'à compiler Winrar en appyant sur la touche "O".
