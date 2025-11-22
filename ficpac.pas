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

function game_over(game_board: Board; var winner: char): boolean;
begin
	winner := check_win(game_board);
	game_over := (winner <> ' ') or board_full(game_board);
end;

function calc_move(game_board: Board; depth: integer; bot_sign: char; player: char): integer;
var
	i: integer;
	j: integer;
	winner: char;
	best_val: integer;
	curr_val: integer;
begin
	winner := check_win(game_board);

	if winner = bot_sign then
		exit(10 - depth)
	else if winner = opposite_player(bot_sign) then
		exit(depth - 10)
	else if board_full(game_board) then
		exit(0);

	if player = bot_sign then
		best_val := -11
	else
		best_val := 11;

	for i := 0 to 2 do
	begin
		for j := 0 to 2 do
		begin
			if not cell_empty(game_board, i * 3 + j) then
				continue;

			game_board[i][j] := player;
			curr_val := calc_move(game_board, depth + 1, bot_sign, opposite_player(player));
			game_board[i][j] := ' ';

			if (player = bot_sign) and (curr_val > best_val) or (player <> bot_sign) and (curr_val < best_val) then
				best_val := curr_val;
		end;
	end;

	calc_move := best_val;
end;

function bot_move(game_board: Board; bot_sign: char): integer;
var
	i: integer;
	j: integer;
	best_val: integer;
	curr_val: integer;
	best_move: integer;
begin
	best_val := -11;

	for i := 0 to 2 do
	begin
		for j := 0 to 2 do
		begin
			if not cell_empty(game_board, i * 3 + j) then
				continue;

			game_board[i][j] := bot_sign;
			curr_val := calc_move(game_board, 0, bot_sign, opposite_player(bot_sign));
			game_board[i][j] := ' ';

			if curr_val > best_val then
			begin
				best_val := curr_val;
				best_move := i * 3 + j;
			end;
		end;
	end;

	bot_move := best_move;
end;

label
	again;
var
	game_board: Board;
	winner: char;
	curr_player: char;
	curr_index: integer;
	bot_mode: boolean;
	i: integer;
begin
	bot_mode := true;
	curr_player := 'x';
	init_board(game_board);

	for i := 1 to ParamCount do
		if (ParamStr(i) = '-p') or (ParamStr(i) = '--player') then
		begin
			bot_mode := false;
			break;
		end;

	if bot_mode then
	begin
		randomize;
		if random(2) = 0 then
			curr_player := 'o';
	end;

	{$I-}
	while not game_over(game_board, winner) do
	begin
		if bot_mode and (curr_player = 'o') then
		begin
			curr_index := bot_move(game_board, opposite_player(curr_player));
			game_board[curr_index div 3][curr_index mod 3] := opposite_player(curr_player);

			if game_over(game_board, winner) then
				break;
		end;

again:
		writeln();
		draw_board(game_board);
		write(curr_player, ' -> ');
		read(curr_index);

		if (IOResult <> 0) or (curr_index > 8) or (curr_index < 0) then
		begin
			writeln('Invalid move!');
			goto again;
		end;

		if not cell_empty(game_board, curr_index) then
		begin
			writeln('Cell is already taken!');
			goto again;
		end;

		game_board[curr_index div 3][curr_index mod 3] := curr_player;

		if bot_mode and (curr_player = 'x') and not board_full(game_board) then
		begin
			curr_index := bot_move(game_board, opposite_player(curr_player));
			game_board[curr_index div 3][curr_index mod 3] := opposite_player(curr_player);
		end;

		if not bot_mode then
			curr_player := opposite_player(curr_player);
	end;

	writeln();
	draw_board(game_board);

	if bot_mode and (winner = curr_player) then
		writeln('You won')
	else if bot_mode and (winner = opposite_player(curr_player)) then
		writeln('You lost')
	else if winner <> ' ' then
		writeln(winner, ' won')
	else
		writeln('Draw');
end.
