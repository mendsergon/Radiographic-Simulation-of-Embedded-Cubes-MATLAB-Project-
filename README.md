## Radiographic Simulation of Embedded Cubes (MATLAB Project)

### Project Summary

This MATLAB project implements a **comprehensive radiographic simulation** that models X-ray transmission through two cubes embedded in a background material. The simulation computes **photon attenuation** using the Beer-Lambert law, incorporates **Poisson noise** to simulate quantum effects, and analyzes image quality under different exposure conditions. The project features **dual-intensity scenarios** (1000 and 100 photons/mm²), **3D geometric visualization**, and **statistical analysis** of transmission patterns. It demonstrates **medical imaging physics**, **noise modeling**, and **computational simulation** techniques for radiographic system analysis.

---

### Core Features

* **Dual-Intensity Simulation:** Models both high-dose (1000 photons/mm²) and low-dose (100 photons/mm²) scenarios
* **Poisson Noise Modeling:** Incorporates statistical quantum noise using MATLAB's `poissrnd()` function
* **Geometric Attenuation Calculation:** Computes path lengths through cubes and background material
* **3D Visualization:** Creates comprehensive visualizations of the experimental setup and ray paths
* **Comprehensive Analysis:** Generates line profiles, noise patterns, and regional statistics
* **Automated Reporting:** Produces detailed reports and saves all results to disk

---

### Key Methods and Algorithms

#### 1. **Geometric Setup and Path Length Calculation**

* **Cube Positioning:** Implements two cubes with specified centers and dimensions:
  - Cube A: 15mm side, center at (96,128,64), μ=0.015 mm⁻¹
  - Cube B: 25mm side, center at (180,128,64), μ=0.005 mm⁻¹
* **Detector Grid:** Creates 256×256 mm detector with 1mm pixel resolution
* **Path Length Computation:** For each detector pixel, calculates intersection lengths with cubes using geometric projection
* **Background Modeling:** 256mm thick background material with μ=0.01 mm⁻¹

#### 2. **Attenuation Physics Implementation**

* **Beer-Lambert Law:** `I = I₀ × exp(-μ₀L₀ - μ₁L₁ - μ₂L₂)` where:
  - μ₀, μ₁, μ₂ are attenuation coefficients for background, cube A, and cube B
  - L₀, L₁, L₂ are corresponding path lengths
* **Total Attenuation Calculation:** `total_attenuation = μ0*background_path + μ1*path_length_A + μ2*path_length_B`

#### 3. **Noise Modeling and Image Generation**

* **Poisson Statistics:** `transmitted_A_noisy = poissrnd(transmitted_A)` simulates quantum noise
* **Dual-Case Analysis:** Generates both noiseless and noisy images for both intensity scenarios
* **Intensity Scaling:** Properly scales images based on incident photon counts

#### 4. **Comprehensive Visualization System**

* **Multi-panel Layouts:** Organized figure layouts showing attenuation maps, transmission images, and analysis results
* **3D Geometric Visualization:** Interactive 3D plot showing cube positions, detector plane, and X-ray paths
* **Line Profile Analysis:** Cross-sectional intensity profiles through cube centers
* **Statistical Visualization:** Bar charts comparing regional mean intensities

#### 5. **Automated Analysis and Reporting**

* **Regional Statistics:** Computes mean photon counts in background, cube A, and cube B regions
* **Noise Pattern Analysis:** Calculates and displays difference between noisy and noiseless images
* **Report Generation:** Creates comprehensive text report with parameters and results summary
* **Data Export:** Saves all images and numerical data in multiple formats

---

### Skills Demonstrated

* **Medical Imaging Physics:** Implementation of radiographic attenuation principles and noise models
* **Computational Geometry:** 3D path length calculations and geometric projections
* **Statistical Modeling:** Poisson noise simulation for quantum-limited imaging
* **Scientific Visualization:** Creation of informative 2D and 3D visualizations
* **Image Processing:** Intensity analysis, line profiles, and regional statistics
* **Data Analysis:** Quantitative comparison of imaging scenarios and noise effects
* **MATLAB Programming:** Efficient matrix operations, function organization, and automated reporting
* **Experimental Design:** Systematic parameter variation and controlled simulation conditions

---

### File Overview

| File Type | Description |
|-----------|-------------|
| **Radiographic_Simulation.m** | Main simulation script with required exercise and extra features |
| **exercise_results/** | Output directory containing all generated files |
| **required_exercise_results.png** | Main results showing both cases with/without noise |
| **3d_visualization.png** | 3D geometric setup with cubes, detector, and ray paths |
| **comprehensive_analysis.png** | 12-panel comprehensive analysis figure |
| **caseA_noiseless.png, caseA_noisy.png** | Individual images for Case A |
| **caseB_noiseless.png, caseB_noisy.png** | Individual images for Case B |
| **attenuation_map.png** | Total attenuation distribution |
| **simulation_data.mat** | Numerical data from simulation |
| **simulation_report.txt** | Comprehensive parameter and results report |

---

### Simulation Output Example

**Key Observations:**
- **High-dose case (1000 photons):** Clear visualization of both cubes with minimal noise impact
- **Low-dose case (100 photons):** Significant noise degradation with reduced contrast-to-noise ratio
- **Attenuation patterns:** Cube A (higher μ) shows stronger attenuation than Cube B despite smaller size
- **Geometric accuracy:** Proper projection of cube shadows onto detector plane
- **Noise characteristics:** Poisson noise visibly affects low-intensity regions more severely

**Quantitative Results (from report):**
```
Case A (1000 photons/mm²):
  Background: 77.5 photons/mm²
  Cube A: 59.8 photons/mm²  
  Cube B: 85.3 photons/mm²
Case B (100 photons/mm²):
  Background: 7.8 photons/mm²
  Cube A: 6.0 photons/mm²
  Cube B: 8.5 photons/mm²
```

---

### How to Run

1. **Execute in MATLAB:** Run the main script `Radiographic_Simulation.m`
2. **View Results:** Check `exercise_results` directory for generated images and report
3. **Analyze Data:** Load `simulation_data.mat` for further numerical analysis
4. **Modify Parameters:** Adjust cube positions, attenuation coefficients, or photon counts in the parameter section

---

### Educational Value

This simulation provides practical understanding of:
- **Radiographic image formation** principles
- **Quantum noise** effects in medical imaging
- **Exposure optimization** trade-offs in radiography
- **Computational methods** for imaging physics
- **Image quality metrics** and analysis techniques
