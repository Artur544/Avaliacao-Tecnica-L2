// Caixa 1: 30 x 40 x 80
// Caixa 2: 80 x 50 x 40
// Caixa 3: 50 x 80 x 60

const url = "/entrada.json";

const caixas = [
    {caixa_tam: 1, dimensoes: { altura: 30, largura: 40, comprimento: 80 }},
    {caixa_tam: 2, dimensoes: { altura: 80, largura: 50, comprimento: 40 }},
    {caixa_tam: 3, dimensoes: { altura: 50, largura: 80, comprimento: 60 }},
];

const vetor_dms = ["altura", "largura", "comprimento"];

// espera a funcao leadOrder e ja imprime a resposta no console
const resDelivery = async () => {
    let res = await loadOrder();
    typeof res === "object" ? console.log(JSON.stringify(res)) : console.log(res)
};

// carrega todo o entrada.json
const loadOrder = async () => {
    let res = await fetch(url);
    let data = await res.json();
    let obj_entrega = {pedidos: []}

    data.pedidos.forEach((order, data_index) => {
        obj_entrega.pedidos.push({pedido_id: order.pedido_id, caixas: []})
        const cont = {}
        order.produtos.forEach((produto, prod_index) => {
            let resVerify = verifyUniSize(produto);
            if (!resVerify) return "Existem produtos maiores que todas as caixas";
            if (cont[resVerify]) cont[resVerify].qt += 1;
            else cont[resVerify] = {qt: 1, prod: []};
            cont[resVerify].prod.push(prod_index);
        });

        obj_entrega.pedidos[data_index].caixas.push(package(
            structuredClone(order.produtos),
            [],
            structuredClone(cont)
        ));
    });
    return obj_entrega;
};

// verifica se um produto cabe em alguma das caixas,
// retorna falso caso o produto seja maior que todas as caixas
// se não, retorna em qual das caixas ele cabe
const verifyUniSize = (produto) => {
    let res = true;
    for (j = 0; j < caixas.length; j++) {
        res = j + 1;
        for (i = 0; i < vetor_dms.length; i++) {
            if (produto.dimensoes[vetor_dms[i]] > caixas[j].dimensoes[vetor_dms[i]]) {
                res = !res
                i += vetor_dms.length
            };
        };
        if (res) return res;
    }
    if (!res) return res;
};

// destribui em quais caixas cada produto deve estar
const package = (produtos, obj_entrega, cont) => {
    if (cont["1"] && cont["1"].qt === 1) {
        obj_entrega.push({ caixa_id: 1, caixa_tam: 1, produtos: produtos[cont["1"].prod[0]] });
        produtos.splice(cont["1"].prod[0], 1);
        delete cont["1"]
    };
    if (produtos.length === 0) return obj_entrega;
    else if (produtos.length === 1) {
        obj_entrega.push({caixa_id: obj_entrega.length + 1, caixa_tam: parseInt(Object.keys(cont)[0]), produtos: produtos });
        return obj_entrega;
    };
    if (Object.keys(cont).length === 1) {
        let prod_rest = []
        for (i = 0; i < produtos.length + prod_rest.length; i++) {
            if (verifyIfCanPack(produtos, parseInt(Object.keys(cont)[0]) - 1)) {
                obj_entrega.push({caixa_id: obj_entrega.length + 1, caixa_tam: parseInt(Object.keys(cont)[0]), produtos: produtos })
                if (prod_rest.length === 0) return obj_entrega;
                else if (prod_rest.length === 1) {
                    obj_entrega.push({caixa_id: obj_entrega.length + 1, caixa_tam: parseInt(Object.keys(cont)[0]), produtos: prod_rest });
                    return obj_entrega;
                }
                let loop_splice = prod_rest.length
                for (j = 0; j < loop_splice; j++) {
                    cont[Object.keys(cont)[0]].prod.splice(0, produtos.length, cont[parseInt(Object.keys(cont)[0]) + 1].prod[0]);
                    produtos.splice(0, produtos.length, prod_rest[0]);
                    prod_rest.splice(0, 1);
                }
                i = 0;
            }
            else {
                let menor_prod = parseInt(compSmallerProduct(produtos))
                let prox_caixa = parseInt(Object.keys(cont)[0]) + 1;
                cont[Object.keys(cont)[0]].prod.splice(menor_prod, 1);
                cont[Object.keys(cont)[0]].qt -= 1;
                if (cont[prox_caixa]) cont[prox_caixa].qt += 1;
                else cont[prox_caixa] = { qt: 1, prod: [] };
                cont[prox_caixa].prod.push(menor_prod);
                prod_rest.push(produtos.splice(menor_prod, 1)[0])
            };
        };
    };
};

// verifica se uma quantidade de produtos que cabem em um certa caixa cabem juntos na mesma,
// retorna true ou false
const verifyIfCanPack = (produtos, caixa_index) => {
    let res = false;
    for (a = 0; a < vetor_dms.length; a++) {
        for (l = 0; l < vetor_dms.length; l++) {
            let soma_dms = produtos[0].dimensoes[vetor_dms[l]];
            for (c = 0; c < vetor_dms.length; c++) {
                for (i = 1; i < produtos.length; i++) {
                    soma_dms += produtos[i].dimensoes[vetor_dms[c]];
                }
                if (soma_dms <= caixas[caixa_index].dimensoes[vetor_dms[a]]) {
                    res = !res;
                    return res;
                };
            };
        };
    };
    return res;
};

// processa uma quantidade de produtos e retorna o indíce do produto de menor volume
const compSmallerProduct = (produtos) => {
    obj_vol = {};
    produtos.forEach((produto, prod_index) => {
        vol = produto.dimensoes["altura"]*produto.dimensoes["largura"]*produto.dimensoes["comprimento"];
        obj_vol[prod_index] = vol;
    })
    return Object.keys(obj_vol).reduce((a, b) => obj_vol[a] < obj_vol[b] ? a : b);
};