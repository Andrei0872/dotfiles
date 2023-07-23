function! s:gotoEditor(...) abort
let dir = a:1
call VSCodeCall(dir == 'next' ? 'workbench.action.nextEditorInGroup' : 'workbench.action.previousEditorInGroup')
endfunction

nnoremap gp <Cmd>call <SID>gotoEditor('prev')<CR>

nnoremap <M-j> <Cmd>m .+1<cr>==

" Code taken from here:
" https://github.com/vscode-neovim/vscode-neovim/issues/200#issuecomment-1245990562.
function! MoveVisualSelection(direction)
	": Summary: This calls the editor.action.moveLines and manually recalculates the new visual selection

	let markStartLine = "'<"                     " Special mark for the start line of the previous visual selection
	let markEndLine =   "'>"                     " Special mark for the end line of the previous visual selection
	let startLine = getpos(markStartLine)[1]     " Getpos(mark) => [?, lineNum, colNumber, ?]
	let endLine = getpos(markEndLine)[1]
	let removeVsCodeSelectionAfterCommand = 1    " We set the visual selection manually after this command as otherwise it will use the line numbers that correspond to the old positions
	let linecount = getbufinfo('%')[0].linecount




	if (a:direction == "Up" && startLine == 1) || (a:direction == "Down" && endLine == linecount) 
	let newStart = startLine
	let newEnd = endLine
	else
	call VSCodeCallRange('editor.action.moveLines'. a:direction . 'Action', startLine, endLine, removeVsCodeSelectionAfterCommand )
	if a:direction == "Up"
	let newStart = startLine - 1
	let newEnd = endLine - 1
	else 
	let newStart = startLine + 1
	let newEnd = endLine + 1
	endif
	endif

	let newVis = "normal!" . newStart . "GV". newEnd . "G"
	":                  │  └──────────────────── " The dot combines the strings together
	":                  └─────────────────────── " ! means don't respect any remaps the user has made when executing
	execute newVis
	endfunction

	":        ┌───────────────────────────────────── " Exit visual mode otherwise our :call will be '<,'>call
	vmap J <Esc>:call MoveVisualSelection("Down")<CR>
	vmap K <Esc>:call MoveVisualSelection("Up")<CR>

