# Unix-homework

Репозиторий с решением задач

<b>Крестики-нолики</b>

xo.sh

Скрипт на bash, реализующий игру крестики-нолики между двумя терминалами на одной машине.
<br>Передача данных между терминалами происходит через FIFO-файл (будет создан /tmp/fifo).

Для начала игры в одном из терминалов следует ввести "x", а в другом что угодно кроме.
<br>Чтобы сделать ход, необходимо указать сначала номер строки, потом столбца, через пробел.
<br>Для завершения игры, нужно ввести "q" в свой ход.
