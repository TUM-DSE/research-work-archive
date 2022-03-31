#!/bin/sh

TABLE_CORNER_SYMBOL="|"
TOP_AND_BOTTOM_ROW=false

table_print_border()
{
    C=$TABLE_CORNER_SYMBOL
    echo "$C------$C-----$C-----$C-----$C----$C"
}

table_print_row()
{
    LABEL=$1
    BSC=$2
    MSC=$3
    IDP=$4
    GR=$5

    printf "| %4s | %3s | %3s | %3s | %2s |\n" "$LABEL" "$BSC" "$MSC" "$IDP" "$GR"
}

table_print_row_for_year_and_semester()
{
    YEAR=$1
    SEMESTER=$2

    set +f
    BSC=$(find ./archive/$YEAR/$SEMESTER/docs -name "bsc*" | wc -l | xargs)
    MSC=$(find ./archive/$YEAR/$SEMESTER/docs -name "msc*" | wc -l | xargs)
    IDP=$(find ./archive/$YEAR/$SEMESTER/docs -name "idp*" | wc -l | xargs)
    GR=$(find ./archive/$YEAR/$SEMESTER/docs -name "gr*" | wc -l | xargs)
    set -f

    if [ "$SEMESTER" = "*" ]; then 
        table_print_row $YEAR $BSC $MSC $IDP $GR
    else
        if [ "$SEMESTER" = "summer" ]; then
            SEMESTER="- SS"
        else
            SEMESTER="- WS"
        fi

        table_print_row "$SEMESTER" "$BSC" "$MSC" "$IDP" "$GR"
    fi
}

if $TOP_AND_BOTTOM_ROW; then
    table_print_border
fi

table_print_row "Year" "BSc" "MSc" "IDP" "GR"
table_print_border

for YEAR in $(ls archive/ | sort -nr); do
    set -f
    table_print_row_for_year_and_semester $YEAR *
    set +f
    table_print_row_for_year_and_semester $YEAR summer
    table_print_row_for_year_and_semester $YEAR winter
done

if $TOP_AND_BOTTOM_ROW; then
    table_print_border
fi
