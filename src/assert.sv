`define ASSERT(signal, value) \
  if (signal !== value) begin \
    $display("ASSERTION FAILED at %s:%d: in %m: signal != value", `__FILE__, `__LINE__); \
    $finish; \
  end

