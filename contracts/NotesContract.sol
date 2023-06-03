// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract NotesContract {
    uint256 public noteCount = 0;

    struct Note {
        uint256 id;
        string agency;
        string cur;
        string rate;
        string amount;
        string total;
        string date;
    }

    mapping(uint256 => Note) public notes;

    event NoteCreated(
        uint256 id,
        string agency,
        string cur,
        string rate,
        string amount,
        string total,
        string date
    );
    event NoteDeleted(uint256 id);

    function createNote(
        string memory _agency,
        string memory _cur,
        string memory _rate,
        string memory _amount,
        string memory _total,
        string memory _date
    ) public {
        notes[noteCount] = Note(
            noteCount,
            _agency,
            _cur,
            _rate,
            _amount,
            _total,
            _date
        );
        emit NoteCreated(
            noteCount,
            _agency,
            _cur,
            _rate,
            _amount,
            _total,
            _date
        );
        noteCount++;
    }

    function deleteNote(uint256 _id) public {
        delete notes[_id];
        emit NoteDeleted(_id);
        noteCount--;
    }
}
