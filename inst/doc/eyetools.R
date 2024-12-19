## ----setup, include=FALSE-----------------------------------------------------

knitr::opts_chunk$set(echo = TRUE,
fig.path = "../man/figures/")

knitr::opts_chunk$set(warning = FALSE) # suppress warnings for easier reading


## ---- eval=FALSE--------------------------------------------------------------
#  install.packages('eyetools')

## -----------------------------------------------------------------------------

library(eyetools)


## -----------------------------------------------------------------------------
data(HCL, package = "eyetools")

dim(HCL)

## -----------------------------------------------------------------------------

head(HCL[HCL$pNum == 118,], 10)


## -----------------------------------------------------------------------------

data <- combine_eyes(HCL)


## -----------------------------------------------------------------------------
head(data) # participant 118

## -----------------------------------------------------------------------------
data <- interpolate(data, maxgap = 150, method = "approx", participant_ID = "pNum")

## -----------------------------------------------------------------------------

interpolate_report <- interpolate(data, maxgap = 150, method = "approx", participant_ID = "pNum", report = TRUE)

interpolate_report[[2]]

## -----------------------------------------------------------------------------
set.seed(0410) #set seed to show same participant and trials in both chunks

data_smooth <- smoother(data,
                        span = .1, # default setting. This controls the degree of smoothing
                        participant_ID = "pNum", 
                        plot = TRUE) # whether to plot or not, FALSE as default

## -----------------------------------------------------------------------------
set.seed(0410) #set seed to show same participant and trials in both chunks

data_smooth <- smoother(data, 
                        span = .02,
                        participant_ID = "pNum",
                        plot = TRUE)

## -----------------------------------------------------------------------------

data_behavioural <- HCL_behavioural # behavioural data

head(data_behavioural)


## -----------------------------------------------------------------------------

data <- merge(data_smooth, data_behavioural) # merges with the common variables pNum and trial

data <- conditional_transform(data, 
                              flip = "x", #flip across x midline
                              cond_column = "cue_order", #this column holds the counterbalance information
                              cond_values = "2",#which values in cond_column to flip
                              message = FALSE) #suppress message that would repeat "Flipping across x midline" 


## -----------------------------------------------------------------------------
data_fixations_disp <- fixation_dispersion(data,
                                           min_dur = 150, # Minimum duration (in milliseconds) of period over which fixations are assessed
                                           disp_tol = 100, # Maximum tolerance (in pixels) for the dispersion of values allowed over fixation period
                                           NA_tol = 0.25, # the proportion of NAs tolerated within any window of samples evaluated as a fixation
                                           progress = FALSE, # whether to display a progress bar or not
                                           participant_ID = "pNum") 

## -----------------------------------------------------------------------------
head(data_fixations_disp) # show sample of output data

## -----------------------------------------------------------------------------

data_fixations_VTI <- fixation_VTI(data[data$pNum == 119,],
                                   threshold = 80, #smoothed data, so use a lower threshold
                                   min_dur = 150, # Minimum duration (in milliseconds) of period over which fixations are assessed
                                   min_dur_sac = 20, # Minimum duration (in milliseconds) for saccades to be determined
                                   disp_tol = 100, # Maximum tolerance (in pixels) for the dispersion of values allowed over fixation period
                                   smooth = FALSE,
                                   progress = FALSE, # whether to display a progress bar or not, when running multiple participants 
                                   participant_ID = "pNum")

## -----------------------------------------------------------------------------
head(data_fixations_VTI) # show sample of output data for participant 118

## -----------------------------------------------------------------------------

saccades <- saccade_VTI(data, participant_ID = "pNum")

head(saccades)


## -----------------------------------------------------------------------------
#some functions are best with single-participant data
data_119 <- data[data$pNum == 119,]

comparison <- compare_algorithms(data_119,
                                 plot_fixations = TRUE,
                                 print_summary = TRUE,
                                 sample_rate = NULL,
                                 threshold = 80, #lowering the default threshold produces a better result when using smoothed data
                                 min_dur = 150,
                                 min_dur_sac = 20,
                                 disp_tol = 100,
                                 NA_tol = 0.25,
                                 smooth = FALSE)

## -----------------------------------------------------------------------------
# set areas of interest
AOI_areas <- data.frame(matrix(nrow = 3, ncol = 4))
colnames(AOI_areas) <- c("x", "y", "width_radius", "height")

AOI_areas[1,] <- c(460, 840, 400, 300) # Left cue
AOI_areas[2,] <- c(1460, 840, 400, 300) # Right cue
AOI_areas[3,] <- c(960, 270, 300, 500) # outcomes

AOI_areas

## -----------------------------------------------------------------------------

data_AOI_time <- AOI_time(data = data_fixations_disp, 
                          data_type = "fix",
                          AOIs = AOI_areas,
                          participant_ID = "pNum")

head(data_AOI_time, 10)

## -----------------------------------------------------------------------------
AOI_time(data = data_fixations_disp,
                          data_type = "fix",
                          AOIs = AOI_areas,
                          participant_ID = "pNum", 
                          as_prop = TRUE, 
                          trial_time = HCL_behavioural$RT) #vector of trial times

## -----------------------------------------------------------------------------
AOI_time(data = data_119, data_type = "raw", AOIs = AOI_areas,
         participant_ID = "pNum")

## -----------------------------------------------------------------------------

binned_time <- AOI_time_binned(data = data_119,
         AOIs = AOI_areas,
         participant_ID = "pNum", 
         bin_length = 100,
         max_time = 2000,
         as_prop = TRUE)

head(binned_time)

## -----------------------------------------------------------------------------

data_AOI_sequence <- AOI_seq(data_fixations_disp,
                             AOI_areas,         
                             AOI_names = NULL,         
                             participant_ID = "pNum")   

head(data_AOI_sequence)

## -----------------------------------------------------------------------------

plot_seq(data_119, trial_number = 1)


## -----------------------------------------------------------------------------

plot_seq(data_119, trial_number = 1, bg_image = "data/HCL_sample_image.jpg") # add background image

plot_seq(data_119, trial_number = 1, AOIs = AOI_areas) # add AOIs


## -----------------------------------------------------------------------------
plot_seq(data_119, trial_number = 1, AOIs = AOI_areas, bin_time = 1000)


## -----------------------------------------------------------------------------
plot_spatial(raw_data = data_119, trial_number = 6)

plot_spatial(fix_data = fixation_dispersion(data_119), trial_number = 6)

plot_spatial(sac_data = saccade_VTI(data_119), trial_number = 6)


## -----------------------------------------------------------------------------
plot_spatial(raw_data = data_119,
             fix_data = fixation_dispersion(data_119),
             sac_data = saccade_VTI(data_119),
             trial_number = 6)


## -----------------------------------------------------------------------------
#standard plot with absolute time
plot_AOI_growth(data = data_119, AOIs = AOI_areas, type = "abs", trial_number = 1)

#standard plot with proportional time
plot_AOI_growth(data = data_119, AOIs = AOI_areas, type = "prop", trial_number = 1)

#only keep predictive and non-predictive cues rather than the target AOI
plot_AOI_growth(data = data_119, AOIs = AOI_areas, type = "prop", AOI_names = c("Predictive", "Non Predictive", NA))


