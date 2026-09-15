# Benchmark Plan

The purpose of benchmarking is to determine whether external cooling raises **sustained useful performance** on the user's actual 14-inch M5 Max and to infer how much fan pressure the upright dock really needs.

## Test order

1. Stock clamshell, no external cooling
2. V12 present but with the custom seal/adapter removed or deliberately unsealed
3. V12 + sealed adapter
4. V12 + sealed adapter at multiple fan speeds
5. Upright V2 on the V12 using the [validation deck](../cad/upright_v2/v12_validation/README.md), after its fit, restraint, load, and leak checks pass
6. The same Upright V2 upper assembly with a quiet 140 mm fan
7. Upright V2 with a higher-static-pressure 140 mm fan, if needed

The V12 deck removes V2's standalone fan and feet. Keep the V2 laptop insert,
gasket, machine settings, and workload fixed when changing pressure sources.
V12-powered success validates that combination, not the standalone fan's pressure
capability. A fan-off run on an obstructed adapter is not the stock baseline.

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

## Standalone V2 follow-up experiments

External review on September 15, 2026 raised these items. They are test proposals,
not changes to the original V2 geometry in the V12-adapter work. The user chose
to finish the V12 adapter first and defer standalone revisions:

- Compare the 20 mm desk intake gap with 30-35 mm before selecting the standalone
  fan. A nominal 140 mm circle has 154 cm² area; a 20 mm peripheral approach gives
  about 88-112 cm² depending on a circular or square boundary. At 35 mm that range
  is about 154-196 cm². These are area estimates, not pressure-loss or fan-curve
  measurements. Test 38 mm-thick fans separately and record their actual clearance.
- After measuring the Mac, compare safe insert sizes while keeping the rest of
  the airflow path fixed. Candidates are 44 × 8, 48 × 8, and 48 × 10 mm, plus the
  maximum opening justified by actual intake/exhaust boundaries. Rounded corners
  slightly reduce the quoted rectangular areas. Use the blank for fit/leak checks,
  not as a powered laptop-cooling configuration.
- Recheck the 96 mm-wide raised cradle and stop locations against the actual Max.
  Narrowing supports may increase exhaust clearance; moving them inward can also
  approach the center intake and change where the load lands. Measure first.
- Consider shallow underside lid ribs if the dummy-load/cable-load test shows
  flex. Any ribs must preserve the air path, nut access, shell-boss clearance,
  and a workable print orientation. Do not treat static laptop weight as the only
  load case.

V12-powered testing isolates the upper airflow path without the standalone fan's
desk-intake restriction. Leave cosmetic redesign until the pressure, interface,
and structural tests establish which geometry is worth keeping.
