build: build_full build_min build_memory build_sprites build_timers

build_min:
	docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -time -bytedump /code/include_me_min.asm

build_full:
	docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -define MEMORY -define SPRITES -define TIMERS -time -bytedump /code/include_me_full.asm

build_sprites:
	docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -define SPRITES -time -bytedump /code/include_me_sprites.asm

build_memory:
	docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -define MEMORY -time -bytedump /code/include_me_memory.asm

build_timers:
	docker run -v ${PWD}:/code barrywalker71/kickassembler:latest -define TIMERS -define MEMORY -time -bytedump /code/include_me_timers.asm

test: build
	docker pull barrywalker71/sim6502cli:latest
	docker run -v ${PWD}:/code -it barrywalker71/sim6502cli:latest -y /code/tests.yaml -s /code/include_me_full.sym