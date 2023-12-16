#lang scribble/manual

@(require (for/label 4chdl racket json) scribble/core)

@title{4chdl --- 4chan image downloader and API library}

@section{4chdl command line image downloader}



@section{API}

@defproc[(4ch-boards) (listof jsexpr?)]{
Get a list of all boards.  This corresponds to the /boards endpoint.
}

@defproc[(4ch-threads [board symbol?]) (listof jsexpr?)]{
Get a list of all threads for the given @racket[board].  This corresponds to the /<board>/threads endpoint.
}

@defproc[(4ch-catalog [board symbol?])  jsexpr?]{
Get catalog content from all threads for the given @racket[board].  This corresponds to the /<board>/catalog endpoint.
}

@defproc[(4ch-archive [board symbol?]) (listof jsexpr?)]{
Get a list of all thread numbers that have been archived for the given @racket[board].  This corresponds to the /<board>/archive endpoint.
}


@defproc[(4ch-archive [board symbol?] [page-no string?]) (listof jsexpr?)]{
Get the @racket[page-no]'th page of threads for the given @racket[board].  This corresponds to the /<board>/<page-no> endpoint.  Hint, you probably don't need this.  See @racket[4ch-catalog].
}


@defproc[(4ch-archive [board symbol?] [thread-no string?]) jsexpr?]{
Get the @racket[thread-no]'th content for the given @racket[board].  This corresponds to the /<board>/thread/<thread-no> endpoint.  Hint, you probably don't need this.
}


@section{Project Information}

@itemlist[
 @item{GPLv3 or later Licensed}
 @item{@hyperlink["https://github.com/winny-/4chdl"]{Source code on GitHub}}
]

@section{See also}

@itemlist[
@item{@hyperlink[]{}}
@item{@hyperlink[]{}}
]