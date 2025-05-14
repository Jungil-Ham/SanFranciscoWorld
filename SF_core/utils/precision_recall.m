%% figure_eval_YUD_precision_recall

clc;
clear;
close all;


Correct = 1;
Wrong   = 1;
Missing = 1;

precision = Correct / (Correct + Wrong)
recall    = Correct / (Correct + Missing)
F_1 = 2 * precision * recall / (precision + recall)
