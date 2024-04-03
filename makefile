ACTION = $(firstword $(MAKECMDGOALS))
MODULE = $(word 2, $(MAKECMDGOALS))

# If the first argument is "test", then the rest of the arguments are the module name
ifeq ($(ACTION),test)
  ifeq ($(MODULE),)
    $(error Module name not provided. Usage: make test <module_name>)
  endif

  # Recipe for testing a specific module
  .PHONY: test
  test:
	@echo "Compiling and running $(MODULE)..."
	iverilog -o build/$(MODULE)-test.vvp $(MODULE)/test.v
	vvp build/$(MODULE)-test.vvp
else
  # Default action
  .PHONY: $(ACTION)
  $(ACTION):
	@echo "Invalid action. Usage: make test <module_name>"
endif

# Clean up
.PHONY: clean
clean:
	rm -f build/*.vvp
