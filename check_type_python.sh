!/bin/bash
#Obtener todos los procesos de Python en ejecución
procesos=$(pgrep python)
#Obtener cmd del proceso de Python en ejecución 
cmd=$(ps -o cmd $procesos | tail -n1)
#Obtener Usuario del proceso de Python en ejecución 
user=$( ps -o user 19067 |tail -n1)

#Verificar si hay al menos un proceso de Python en ejecución
if [ -z "$procesos" ]; then

#Si no hay procesos de Python en ejecución, mostrar mensaje y salir con código de estado 0
echo "OK - No hay procesos de Python en ejecución"
exit 0
fi

#Verificar si se han pasado los parámetros -w y -c
if [ "$1" != "-w" ] || [ "$3" != "-c" ]; then

#Si no se han pasado los parámetros correctamente, mostrar mensaje y salir con código de estado 3
echo "UNKNOWN - Uso incorrecto del script. Utilice: check_type_python.sh -w tiempo_warning -c tiempo_critical"
exit 3
fi

#Verificar si tiempo_warning es menor que tiempo_critical
if [ "$2" -gt "$4"]; then 
echo "UNKNOWN - El tiempo de warning debe ser menor que el tiempo de critical"
exit 3 
fi 


#Asignar a variables el tiempo de warning y el tiempo de critical pasados como parámetros
tiempo_warning=$2
tiempo_critical=$4

#Recorrer cada proceso de Python en ejecución
for proceso in $procesos; do

#Obtener el tiempo de ejecución del proceso en formato horas:minutos:segundos
tiempo2=$(ps -o etime $proceso | tail -n 1 |awk '{print $1}')

#Obtener el tiempo de ejecución del proceso en formato  segundos
tiempo_segundos=$(ps -o etimes $proceso | tail -n 1)

#Verificar si el tiempo de ejecución es mayor al tiempo de warning o al tiempo de critical
if [ "$tiempo_segundos" -gt "$tiempo_warning" ] || [ "$tiempo_segundos" -gt "$tiempo_critical" ]; then
# Si el tiempo de ejecución es mayor al tiempo de warning o al tiempo de critical, mostrar mensaje y salir con código de estado 1 o 2 respectivamente
if [ "$tiempo_segundos" -gt "$tiempo_warning" ]; then
echo "WARNING - Esta en ejecución: $cmd con el usuario: $user con el pid: $procesos tiempo ejecutandose: $tiempo2"
exit 1
else
echo "CRITICAL - Hay al menos un proceso de Python en ejecución por más de $(timepo2)"
exit 2
fi
fi
done

#  Si no se cumplió ninguna condición anterior, mostrar mensaje y salir con código de estado 0:

#Si se llegó hasta aquí, es porque todos los procesos de Python en ejecución tienen menos del tiempo de ejecución asignado a monitorear
echo "OK - Todos los procesos de Python en ejecución estan corriendo en el tiempo correspondiente"
exit 0
