#' @export
#' @title fix border issues when cell are merged
#' @description When cells are merged, the rendered borders will be those
#' of the first cell. If a column is made of three merged cells, the bottom
#' border that will be seen will be the bottom border of the first cell in the
#' column. From a user point of view, this is wrong, the bottom should be the one
#' defined for cell 3. This function modify the border values to avoid that effect.
#' @param x flextable object
#' @param part partname of the table (one of 'all', 'body', 'header', 'footer')
#' @examples
#' if( require(magrittr) ){
#'   library(officer)
#'   ft <- data.frame(a = 1:5, b = 6:10) %>%
#'     flextable() %>%
#'     theme_box() %>%
#'     merge_at(i = 4:5, j = 1, part = "body") %>%
#'     hline(i = 5, part = "body",
#'           border = fp_border(color = "red", width = 5) )
#'   print(ft)
#'   fix_border_issues(ft) %>% print()
#' }
fix_border_issues <- function(x, part = "body"){

  if( !inherits(x, "flextable") ) stop("fix_border_issues supports only flextable objects.")
  part <- match.arg(part, c("body", "header", "footer"), several.ok = FALSE )

  x[[part]] <- correct_h_border(x[[part]])
  x[[part]] <- correct_v_border(x[[part]])
  x
}

correct_h_border <- function(x){

  span_cols <- as.list(as.data.frame(x$spans$columns))

  bool_to_be_corrected <- lapply( span_cols, function(x) x > 1 )
  l_apply_bottom_border <- lapply( span_cols, function(x) {
    rle_ <- rle(x)
    from <- cumsum(rle_$lengths)[rle_$values < 1]
    to <- cumsum(rle_$lengths)[rle_$values > 1]
    list(from = from, to = to, dont = length(to) < 1 )
  })

  for(j in seq_len(ncol(x$spans$columns)) ){
    apply_bottom_border <- l_apply_bottom_border[[j]]

    if( apply_bottom_border$dont ) next

    for( i in seq_along(apply_bottom_border$from) ){
      i_from <- apply_bottom_border$from[i]
      i_to <- apply_bottom_border$to[i]

      x$styles$cells$border.color.bottom[i_to, x$col_keys[j]] <- x$styles$cells$border.color.bottom[i_from, x$col_keys[j]]
      x$styles$cells$border.width.bottom[i_to, x$col_keys[j]] <- x$styles$cells$border.width.bottom[i_from, x$col_keys[j]]
      x$styles$cells$border.style.bottom[i_to, x$col_keys[j]] <- x$styles$cells$border.style.bottom[i_from, x$col_keys[j]]
    }

  }

  x
}
correct_v_border <- function(x){

  span_rows <- as.list(as.data.frame(t(x$spans$rows)))

  l_apply_right_border <- lapply( span_rows, function(x) {
    rle_ <- rle(x)
    from <- cumsum(rle_$lengths)[rle_$values < 1]
    to <- cumsum(rle_$lengths)[rle_$values > 1]
    list(from = from, to = to, dont = length(to) < 1 )
  })

  for(i in seq_along(l_apply_right_border) ){

    apply_right_border <- l_apply_right_border[[i]]

    if( apply_right_border$dont ) next

    for( j in seq_along(apply_right_border$from) ){

      colkeyto <- x$col_keys[apply_right_border$to[j]]
      colkeyfrom <- x$col_keys[apply_right_border$from[j]]
      x$styles$cells$border.color.right[i, colkeyto] <- x$styles$cells$border.color.right[i, colkeyfrom]
      x$styles$cells$border.width.right[i, colkeyto] <- x$styles$cells$border.width.right[i, colkeyfrom]
      x$styles$cells$border.style.right[i, colkeyto] <- x$styles$cells$border.style.right[i, colkeyfrom]

    }

  }

  x
}