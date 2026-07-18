import pandas as pd
import numpy as np

def clr_transform(df, pseudocount=None):
    """
    Perform a centered log-ratio (CLR) transformation on a samples x taxa
    relative abundance dataframe.

    Parameters
    ----------
    df : pd.DataFrame
        Rows = samples, columns = taxa. Values should be relative abundances
        (proportions or percentages, all >= 0).
    pseudocount : float or None
        Value added to all entries before taking logs, to handle zeros.
        If None, defaults to half the smallest non-zero value in the
        entire dataframe (a common convention).

    Returns
    -------
    pd.DataFrame
        CLR-transformed values, same shape/index/columns as input.
    """
    data = df.copy().astype(float)

    if pseudocount is None:
        min_nonzero = data[data > 0].min().min()
        pseudocount = min_nonzero / 2

    data = data + pseudocount

    # geometric mean per sample (row), computed in log-space for stability
    log_data = np.log(data)
    gm_log = log_data.mean(axis=1)  # mean of logs = log of geometric mean

    clr_df = log_data.sub(gm_log, axis=0)

    return clr_df

# usage
#clr_result = clr_transform(wirbelj_relab_taxa)

def z_normalize(df, axis=0):
    """
    Z-normalize a dataframe (subtract mean, divide by std).

    Parameters
    ----------
    df : pd.DataFrame
    axis : int
        0 = normalize each column (taxon) across samples — the usual choice
            for ML, so each feature has mean 0, std 1 across your cohort.
        1 = normalize each row (sample) across taxa — less common, only
            makes sense if you have a specific reason to compare within-sample.

    Returns
    -------
    pd.DataFrame, same shape/index/columns
    """
    std = df.std(axis=0) if axis == 0 else df.std(axis=1)
    zero_var = std[std == 0].index.tolist()
    if zero_var:
        import warnings
        warnings.warn(f"{len(zero_var)} zero-variance column(s) found: {zero_var[:5]}{'...' if len(zero_var) > 5 else ''}")
    if axis == 0:
        mean, std = df.mean(axis=0), df.std(axis=0)
        result = (df - mean) / std
        zero_var_cols = std[std == 0].index
        result[zero_var_cols] = 0.0
        return result
    else:
        mean, std = df.mean(axis=1), df.std(axis=1)
        result = df.sub(mean, axis=0).div(std, axis=0)
        zero_var_rows = std[std == 0].index
        result.loc[zero_var_rows] = 0.0
        return result

# usage — typically applied AFTER CLR, per-taxon
#z_df = z_normalize(clr_result, axis=0)

def presence_absence(df):
    """
    Encode any presence as 1 in a dataframe.
    Anything above 0 is replaced by a 1.

    Parameters
    ----------
    df : pd.DataFrame

    Returns
    -------
    pd.DataFrame, same shape/index/columns
    """

    data = df.copy().astype(float)

    data_binary = (data != 0).astype(int)

    return data_binary


