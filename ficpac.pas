program ficpac;

type
	Board = array[0..2, 0..2] of char;

procedure init_board(var game_board: Board);
var
	i: integer;
	j: integer;
begin
	for i := 0 to 2 do
		for j := 0 to 2 do
			game_board[i][j] := ' ';
end;

procedure draw_board(game_board: Board);
var
	i: integer;
	j: integer;
begin
	for i :=  0 to 2 do
	begin
		for j := 0 to 2 do
		begin
			if (game_board[i][j] = 'x') or (game_board[i][j] = 'o') then
				write(' ', game_board[i][j], ' ')
			else
				write('[', i * 3 + j, ']');
			if j < 2 then
				write('|');
		end;
		writeln();
		if i < 2 then
			writeln('---|---|---');
	end;
end;

function opposite_player(player: char): char;
begin
	if player = 'x' then
		opposite_player := 'o'
	else if player = 'o' then
		opposite_player := 'x';
end;

function cell_empty(game_board: Board; index: integer): boolean;
begin
	if (game_board[index div 3][index mod 3] <> 'x') and (game_board[index div 3][index mod 3] <> 'o') then
		cell_empty := true
	else
		cell_empty := false;
end;

function board_full(game_board: Board): boolean;
var
	i: integer;
	j: integer;
begin
	board_full := false;

	for i := 0 to 2 do
		for j := 0 to 2 do
			if cell_empty(game_board, i * 3 + j) then
				exit;

	board_full := true;
end;

function check_win(game_board: Board): char;
var
	i: integer;
begin
	for i := 0 to 2 do
		if (game_board[i][0] <> ' ') and (game_board[i][0] = game_board[i][1]) and (game_board[i][0] = game_board[i][2]) then
			exit(game_board[i][0]);

	for i := 0 to 2 do
		if (game_board[0][i] <> ' ') and (game_board[0][i] = game_board[1][i]) and (game_board[0][i] = game_board[2][i]) then
			exit(game_board[0][i]);

	if (game_board[0][0] <> ' ') and (game_board[0][0] = game_board[1][1]) and (game_board[0][0] = game_board[2][2]) then
		exit(game_board[0][0]);

	if (game_board[2][0] <> ' ') and (game_board[2][0] = game_board[1][1]) and (game_board[2][0] = game_board[0][2]) then
		exit(game_board[2][0]);

	check_win := ' ';
end;

var
	game_board: Board;
	winner: char;
	curr_player: char;
	curr_index: integer;
begin
	curr_player := 'x';
	init_board(game_board);

	{$I-}
	while not board_full(game_board) do
	begin
		writeln();
		draw_board(game_board);
		write(curr_player, ' -> ');
		read(curr_index);

		if (IOResult <> 0) or (curr_index > 8) or (curr_index < 0) then
		begin
			writeln('Invalid move!');
			continue;
		end;

		if not cell_empty(game_board, curr_index) then
		begin
			writeln('Cell is already taken!');
			continue;
		end;

		game_board[curr_index div 3][curr_index mod 3] := curr_player;

		winner := check_win(game_board);
		writeln('[DEBUG] check_win -> ', winner);
		if winner <> ' ' then
			break;

		curr_player := opposite_player(curr_player);
	end;

	writeln();
	draw_board(game_board);

	if winner <> ' ' then
		writeln(winner, ' won')
	else
		writeln('Draw');
end.
