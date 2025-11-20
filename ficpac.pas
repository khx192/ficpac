program ficpac;

type
	Board = array[0..2, 0..2] of char;

procedure clean_board(var game_board: Board);
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

procedure switch_player(var player: char);
begin
	if player = 'x' then
		player := 'o'
	else if player = 'o' then
		player := 'x';
end;

function cell_empty(game_board: Board; index: integer): boolean;
begin
	if (game_board[index div 3][index mod 3] <> 'x') and (game_board[index div 3][index mod 3] <> 'o') then
		cell_empty := true
	else
		cell_empty := false;
end;

function check_win(game_board: Board; player: char): boolean;
var
	i: integer;
begin
	check_win := true;

	for i := 0 to 2 do
		if (game_board[i][0] = game_board[i][1]) and (game_board[i][0] = game_board[i][2]) and (game_board[i][0] = player) then
			exit;

	for i := 0 to 2 do
		if (game_board[0][i] = game_board[1][i]) and (game_board[0][i] = game_board[2][i]) and (game_board[0][i] = player) then
			exit;

	if (game_board[0][0] = game_board[1][1]) and (game_board[0][0] = game_board[2][2]) and (game_board[0][0] = player) then
		exit;

	if (game_board[2][0] = game_board[1][1]) and (game_board[2][0] = game_board[0][2]) and (game_board[2][0] = player) then
		exit;

	check_win := false;
end;

var
	game_board: Board;
	win_state: boolean;
	cells_left: integer;
	curr_player: char;
	curr_index: integer;
begin
	win_state := false;
	cells_left := 9;
	curr_player := 'x';
	clean_board(game_board);

	{$I-}
	while cells_left > 0 do
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

		if check_win(game_board, curr_player) then
		begin
			win_state := true;
			break;
		end;

		switch_player(curr_player);
		cells_left -= 1;
	end;

	writeln();
	draw_board(game_board);
	if win_state then
		writeln(curr_player, ' won')
	else
		writeln('Draw');
end.
