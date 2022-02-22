//SPDX-License-Identifier: Unlicense
pragma solidity ^0.4.24;

/**
 * @title TicTacToe contract
 **/
contract TicTacToe {
    address[2] public players;

    /**
     turn
     1 - players[0]'s turn
     2 - players[1]'s turn
     */
    uint public turn = 1;

    /**
     status
     0 - ongoing
     1 - players[0] won
     2 - players[1] won
     3 - draw
     */
    uint public status;

    /**
    board status
     0    1    2
     3    4    5
     6    7    8
     */
    uint[9] private board;

    /**
      * @dev Deploy the contract to create a new game
      * @param opponent The address of player2
      **/
    constructor(address opponent) public {
        // Necessary requirement in order to be two different players
        require(msg.sender != opponent, "No self play");
        // Sender is 0, Opponent is 1
        players = [msg.sender, opponent];
    }

    /**
      * @dev Check a, b, c in a line are the same
      * _threeInALine doesn't check if a, b, c are in a line
      * @param a position a
      * @param b position b
      * @param c position c
      **/    
    function _threeInALine(uint a, uint b, uint c) private view returns (bool){
        /*Please complete the code here.*/
        // a cannot be 0 and must be same as other two integers
        return (a != 0 && a == b && a == c);
    }

    /**
     * @dev get the status of the game
     * @param pos the position the player places at
     * @return the status of the game
     */
    function _getStatus(uint pos) private view returns (uint) {
        /*Please complete the code here.*/

        // Extract row and column in board from position
        uint row = pos / 3;
        uint column = pos % 3;

        // Check if three elements are the same in row, column and the two diagonals
        bool winRow = _threeInALine(board[row * 3], board[row * 3 + 1], board[row * 3 + 2]);
        bool winCol = _threeInALine(board[column], board[column + 3], board[column + 6]);
        bool WinDiag1 = _threeInALine(board[0], board[4], board[8]);
        bool WinDiag2 = _threeInALine(board[2], board[4], board[6]);

        // Check if the board contains a winner
        if (winRow || winCol || WinDiag1 || WinDiag2){
          return board[pos]; // Returns winning value (1 or 2)
        }

        // Check for draw
        bool isDraw = true;
        for (uint i=0; i < board.length; i++) {
          if (board[i] == 0) { // If empty cell exists, then not a draw
            isDraw = false;
          }
        }
        if (isDraw)
          return 3;


        // If we reached this point, game is ongoing
        return 0;
    }

    /**
     * @dev ensure the game is still ongoing before a player moving
     * update the status of the game after a player moving
     * @param pos the position the player places at
     */
    modifier _checkStatus(uint pos) {
        /*Please complete the code here.*/
        // This ensures that the game is still ongoing
        require(status == 0);
        _;
        // Update the status of the game
        status = _getStatus(pos);
    }

    /**
     * @dev check if it's msg.sender's turn
     * @return true if it's msg.sender's turn otherwise false
     */
    function myTurn() public view returns (bool) {
       /*Please complete the code here.*/
        if (msg.sender == players[0]) {
          return (turn == 1);
        } else if (msg.sender == players[1]) {
          return (turn == 2);
        }
        return false;
    }

    /**
     * @dev ensure it's a msg.sender's turn
     * update the turn after a move
     */
    modifier _myTurn() {
      /*Please complete the code here.*/
      require (myTurn() == true);
      _;
      if (turn == 1){
        turn = 2;
      } else {
        turn = 1;
      }
      // _;
    }

    /**
     * @dev check a move is valid
     * @param pos the position the player places at
     * @return true if valid otherwise false
     */
    function validMove(uint pos) public view returns (bool) {
      /*Please complete the code here.*/
      // In solidity, uint array cells are initialised to 0,
      // so we check if its still 0 for the move to be valid.
      // We also check if pos is within the bound of the array.
      return (board[pos] == 0 && pos >= 0 && pos < board.length);
    }

    /**
     * @dev ensure a move is valid
     * @param pos the position the player places at
     */
    modifier _validMove(uint pos) {
      /*Please complete the code here.*/
      require(validMove(pos) == true);
      _;
    }

    /**
     * @dev a player makes a move
     * @param pos the position the player places at
     */
    function move(uint pos) public _validMove(pos) _checkStatus(pos) _myTurn {
        board[pos] = turn;
    }

    /**
     * @dev show the current board
     * @return board
     */
    function showBoard() public view returns (uint[9]) {
      return board;
    }
}
