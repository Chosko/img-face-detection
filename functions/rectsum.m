function s = rectsum(I, top, right, bottom, left)
% function s = rectsum(I, X, Y)
%   Ritorna la somma dei valori di tutti i pixel compresi in un rettangolo.
%   Parametri:
%   - I: L'immagine integrale
%   - top: Il bordo superiore del rettangolo
%   - right: Il bordo destro del rettangolo
%   - bottom: Il bordo inferiore del rettangolo
%   - left: Il bordo sinistro del rettangolo

s = I(bottom, right) - I(top, right) - I(bottom, left) + I(top, left);