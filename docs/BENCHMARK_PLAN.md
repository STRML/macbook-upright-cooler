# Benchmark Plan

The purpose of benchmarking is to determine whether external cooling raises **sustained useful performance** on the user's actual 14-inch M5 Max and to infer how much fan pressure the upright dock really needs.

## Test order

1. Stock clamshell, no external cooling
2. V12 present but with the custom seal/adapter removed or deliberately unsealed
3. V12 + sealed adapter
4. V12 + sealed adapter at multiple fan speeds
5. Upright prototype with a quiet 140 mm fan
6. Upright prototype with a higher-static-pressure 140 mm fan, if needed

Do not consider an internal thermal-pad modification until these results are understood.

## Workloads

Use workloads that resemble actual use rather than only short synthetic tests.

### AI

Use the same model, quantization, context, prompt, and generation settings for every run. Record at minimum:

- prompt processing / prefill speed where available
- decode tokens/sec
- time to first token
- total wall time
- sustained GPU/SoC power if available
- GPU/CPU clocks if available
- fan RPM and temperatures

A 20-30 minute repeated workload is preferable to a single short prompt.

### Compiles

Use a reproducible clean build large enough to heat-soak the machine. Record:

- wall-clock compile time
- sustained CPU package power
- P-core clocks if available
- Apple fan RPM
- temperatures

Repeat each configuration enough times to distinguish thermal behavior from build-cache/noise effects.

## Fan-speed sweep

The V12 is useful as an experimental pressure source. The most valuable first sweep is approximately:

- low
- medium-low
- medium
- medium-high
- maximum

Use the V12's actual available RPM/readout points if exposed rather than forcing arbitrary targets.

The design decision to make afterward is not "which RPM is coolest?" but rather:

> At what fan setting does sustained package power / workload throughput stop meaningfully improving?

If performance plateaus at low or moderate V12 speed, the final upright dock can likely use a quieter conventional 140 mm fan. If performance continues scaling near maximum V12 speed, use a high-static-pressure fan or blower instead.

## Keep ambient conditions sane

- Record room temperature.
- Let the machine return to a similar starting state between cold-start comparisons, or deliberately compare steady-state repeated loads.
- Keep power mode and charger constant.
- Keep display/clamshell state constant.
- Avoid changing unrelated software between A/B runs.

## Success criteria

Primary: more completed work per unit time after thermal equilibrium.

Secondary:

- higher sustained SoC / CPU / GPU power at similar temperature
- higher sustained clocks
- lower Apple internal-fan RPM at equal performance

Temperature by itself is not the main success metric.
