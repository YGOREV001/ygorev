# ygorev
EDOPRO/YGOPRO - YGOREV files

YGOREV Project

Created by Mauricio Berrío

Dev/Test Staff:

Omar Hernández
Jeffer Guerrero
Miguel Calderón
Juan Corredor
Jonathan Torres

This is the repository for YGOREV project applied on EDOPRO/YGOPRO

--UPDATES VERSION 1.2.0--
2022-08-08: Corrección efecto "Invisible Wire": Permitía activación si un monstruo del controlador atacaba.
Update 20220809: Corrección Monstruos Toon, salían como FLIP

Updates 20220810:
Suzaku -> Se infla con FIRE boca abajo	OK
Fusion Sage -> Obliga a activar todo el backrow para resolver el -2000	OK (No se pudo replicar el error, pero se hicieron ajustes menores)
Teddy -> Sólo se activa al atacar monstruos Lv5 o mayor	OK
Trap Hole -> Se activa con Effect Monsters	OK
Mirror Wall -> No está aplicando el OPT	OK
Dark Rabbit + Toon Alligator -> *Ajustes a Toon Flip Monsters: No hay forma de registrar monstruos Toon que a la vez sean Flip en EDOPro. Se configurarán por defecto como FLIP, pero siempre serán tratados como Toon.

Update 20220812:
Mirror Wall -> Permite activar el efecto incluso si el controlador ataca con un monstruo suyo	OK
D. Human -> Permite convocar en posición de ataque	OK
Acid Trap Hole -> No funciona al invocar Normal Summon	OK
Final Flame -> Mantiene la reducción de ATK/DEF incluso si el monstruo abandona el campo y es revivido	OK
Sea Kamen -> No puede activar el efecto si el campo está lleno	OK
Legendary Naiad -> Error de código (Error en filtrado de monstruos para eff de revivir)	OK