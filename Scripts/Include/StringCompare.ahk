; Calculates the Levenshtein distance between two strings.
; Parameters:
;   s1 - The first string.
;   s2 - The second string.
; Returns:
;   The minimum number of single-character edits (insertions, deletions, or substitutions) required to transform s1 into s2.
Levenshtein(s1, s2)
{
    m := StrLen(s1)
    n := StrLen(s2)
    
    dp := []
    Loop, % m + 1
        dp[A_Index] := []
    
    Loop, % m + 1
    {
        i := A_Index - 1
        Loop, % n + 1
        {
            j := A_Index - 1
            if (i = 0)
                dp[i, j] := j
            else if (j = 0)
                dp[i, j] := i
            else if (SubStr(s1, i, 1) = SubStr(s2, j, 1))
                dp[i, j] := dp[i - 1, j - 1]
            else
                dp[i, j] := Min(dp[i - 1, j], dp[i, j - 1], dp[i - 1, j - 1]) + 1
        }
    }
    return dp[m, n] ;Levenshtein Distance
}

; Computes the similarity between two strings using the Levenshtein distance method.    
; Parameters:
;   s1 (String) - The first input string.
;   s2 (String) - The second input string.
; Returns:
;   (Float) - A similarity value (0.0 to 1.0), where 1.0 means identical strings.
SimilarityScore(s1, s2)
{
    maxLength := Max(StrLen(s1), StrLen(s2))
    if (maxLength = 0) {
        return 1.0
    }
    return 1 - (Levenshtein(s1, s2) / maxLength)
}