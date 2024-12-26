DROP PROCEDURE `calcular_bonus`;
DELIMITER $$
	CREATE PROCEDURE calcular_bonus(IN id_seller INT, OUT accumulated_monthly_bonus DECIMAL(10,2))
	BEGIN
		DECLARE done BOOLEAN DEFAULT FALSE;
		DECLARE sale_value DECIMAL(10,2) DEFAULT 0;
        DECLARE percent INT DEFAULT 5;
		DECLARE percent_value DECIMAL(10,2) DEFAULT 0;
        DECLARE total_sale DECIMAL(10,2) DEFAULT 0;
		DECLARE sales_values CURSOR FOR SELECT ValorVenda FROM vendas WHERE VendedorID = id_seller;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        SET accumulated_monthly_bonus = 0;
        SELECT SUM(ValorVenda) INTO total_sale FROM vendas WHERE VendedorID = id_seller;
		OPEN sales_values;
			cursor_loop: LOOP
				FETCH sales_values INTO sale_value;  
				IF done THEN
					LEAVE cursor_loop;
                END IF;   
                IF total_sale > 50000 THEN
					SET percent = 7;
                END IF;
                SET percent_value = percent * sale_value / 100;
                SET accumulated_monthly_bonus = accumulated_monthly_bonus + percent_value;
            END LOOP;
		CLOSE sales_values;
	END $$
DELIMITER ;

CALL calcular_bonus(4, @bonus);
SELECT @bonus;

SELECT * FROM vendas;