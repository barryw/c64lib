clean:
	rm -f *.sym
	rm -f *.prg
	rm -f ByteDump.txt

build: clean build_full build_min build_memory build_sprites build_timers

build_min:
	@echo Building minimum library
	@docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -time -bytedump /code/include_me_min.asm

build_full:
	@echo Building full library
	@docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -define MEMORY -define SPRITES -define TIMERS -time -bytedump /code/include_me_full.asm
	@docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -define MEMORY -define SPRITES -define TIMERS -time -bytedump /code/include_me_full_r.asm

build_sprites:
	@echo Building sprite library
	@docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -define SPRITES -time -symbolfile -bytedump /code/include_me_sprites.asm
	@docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -define SPRITES -time -symbolfile -bytedump /code/include_me_sprites_r.asm

build_memory:
	@echo Building memory library
	@docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -define MEMORY -time -bytedump /code/include_me_memory.asm

build_timers:
	@echo Building timer library
	@docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -define TIMERS -define MEMORY -time -bytedump /code/include_me_timers.asm

test: build
	@docker pull barrywalker71/sim6502cli:latest
	@docker run -v ${PWD}:/code -it barrywalker71/sim6502cli:latest -s /code/tests.6502 -t
