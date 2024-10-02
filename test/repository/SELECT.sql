SELECT 
        Artigo,
        ART.Descricao, 
        ART.Status,  
        ((CAST(SUM(DATEDIFF(DAY, 
            IIF(MONTH(DataInicio) < @Mes, DATEFROMPARTS(YEAR(DataFim), MONTH(DataFim), 1), DataInicio), 
            IIF(MONTH(DataFim) > @Mes, EOMONTH(DataInicio), DataFim))) AS FLOAT) + 1) / @NumDiasMes) * 100 AS Taxa