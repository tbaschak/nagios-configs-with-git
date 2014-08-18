SRCS		= nagios-configs-with-git.md
PDFOBJS		= $(SRCS:.md=.pdf)
SLIDEOBJS	= $(SRCS:.md=.html)
PANDOC		= pandoc
PFLAGS		= -t beamer

.PHONY: all clean slides pdf mirror

all: slides $(PDFOBJS)
	@echo Slides and PDF generated

%.pdf:	%.md
	$(PANDOC) $(PFLAGS) $< -o $@

pdf:  $(PDFOBJS)

slides: 
	pandoc -V theme=default -s -S -t revealjs --mathjax $(SRCS) -o $(SLIDEOBJS)

clean: cleanpdf cleanslides

cleanpdf:
	rm -f $(PDFOBJS)

cleanslides:
	rm -f $(SLIDEOBJS) 

mirror:
	git push --mirror github

gh-pages: slides pdf
	git add nagios-configs-with-git.html nagios-configs-with-git.pdf
	git commit -m 'generate latest slides via Makefile'
	git push -u origin master
	git checkout gh-pages
	git checkout master -- nagios-configs-with-git.html
	git checkout master -- nagios-configs-with-git.pdf
	cp nagios-configs-with-git.html index.html
	git add nagios-configs-with-git.html nagios-configs-with-git.pdf index.html
	git commit -m 'pull in latest generated slides from master branch'
	git push -u origin gh-pages
	git checkout master
	@echo Slides generated and pushed to gh-pages branch
