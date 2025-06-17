_ != mkdir -p .make

GO     ?= go
CFORGO ?= $(GO) tool c-for-go

CGO_SRC     := $(addprefix cgo_helpers,.h .go .c)
GO_SRC      := $(addsuffix .go,types gnumake)
GNUMAKE_SRC := $(addprefix gnumake/,${CGO_SRC} ${GO_SRC})

build: .make/go-build
generate gen: ${CGO_SRC} ${GO_SRC}
tidy: go.sum

${GNUMAKE_SRC}: gnumake.yml
	$(CFORGO) -out ${CURDIR} $<
${GO_SRC} ${CGO_SRC}: ${GNUMAKE_SRC}
	cp $? .

go.sum: go.mod ${GO_SRC}
	$(GO) mod tidy

.make/go-build: ${GO_SRC}
	$(GO) build ./...
	@touch $@
