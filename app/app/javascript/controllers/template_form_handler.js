document.addEventListener('turbo:load', () => {
    const formContainer = document.querySelector('.template-form-container');
    if (!formContainer) return;

    let questionIndex = 3; // Começa após Questão 2 (mock)

    // --- Funções de Manipulação do DOM ---

    // 1. Alterna a visibilidade do campo 'Opções'
    const toggleOptionsVisibility = (typeSelect) => {
        // Encontra o container da questão (elemento pai mais próximo que contém todos os campos)
        const questionBlock = typeSelect.closest('.js-question-block');
        if (!questionBlock) return;

        // Encontra o container de opções e o botão de adição de opções dentro do bloco
        const optionsContainer = questionBlock.querySelector('.js-options-container');
        const addOptionButton = questionBlock.querySelector('.js-add-option-button');

        if (typeSelect.value === 'Radio') {
            if (optionsContainer) optionsContainer.classList.remove('hidden');
            if (addOptionButton) addOptionButton.classList.remove('hidden');
        } else {
            if (optionsContainer) optionsContainer.classList.add('hidden');
            if (addOptionButton) addOptionButton.classList.add('hidden');
        }
    };

    // 2. Adiciona um novo campo de Opção (botão cinza '+')
    const addOptionField = (event) => {
        event.preventDefault();
        const optionList = event.target.closest('.js-question-block').querySelector('.js-options-list');
        if (!optionList) return;

        const newOptionInput = document.createElement('div');
        newOptionInput.classList.add('mt-2');
        // Usamos um nome de campo genérico que o Rails precisará processar como array (e.g., questions[][options][])
        newOptionInput.innerHTML = `
            <input type="text" placeholder="Nova Opção" class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1">
        `;
        optionList.appendChild(newOptionInput);
    };

    // 3. Adiciona uma nova Questão completa (botão roxo '+')
    const addNewQuestionBlock = (event) => {
        event.preventDefault();

        const newQuestionHTML = `
            <div class="mb-6 border-b border-gray-200 pb-4 js-question-block">
                <h2 class="text-xl font-bold text-gray-800 mb-4">Questão ${questionIndex}</h2>
                
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Tipo:</label>
                        <select class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1 js-type-select">
                            <option value="Radio">Radio</option>
                            <option value="Texto">Texto</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Texto:</label>
                        <input type="text" placeholder="Placeholder" class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1">
                    </div>
                </div>
                
                <div class="mt-4 js-options-container">
                    <label class="block text-sm font-medium text-gray-700">Opções:</label>
                    <div class="js-options-list">
                        <input type="text" placeholder="Opção 1" class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1">
                    </div>
                </div>
                
                <div class="mt-4 flex justify-center js-add-option-button">
                    <button type="button" class="h-8 w-8 rounded-full bg-gray-300 text-gray-700 hover:bg-gray-400 flex items-center justify-center js-add-option">
                        <span class="text-xl font-light">+</span>
                    </button>
                </div>
            </div>
        `;

        // Insere o novo bloco antes do botão roxo de adicionar questão
        const mainAddButtonContainer = event.target.closest('.js-main-add-button-container');
        if (mainAddButtonContainer) {
            mainAddButtonContainer.insertAdjacentHTML('beforebegin', newQuestionHTML);
        }

        questionIndex++;

        // Re-atribui listeners após a adição de novos elementos
        attachListeners();
    };

    // --- Inicialização e Atribuição de Listeners ---

    const attachListeners = () => {
        // Remove listeners antigos para evitar duplicação (especialmente importante com Turbo)
        // (Simplificado, mas idealmente seria necessário um cleanup mais formal)

        // Listeners para Tipo de Questão (Select)
        formContainer.querySelectorAll('.js-type-select').forEach(select => {
            // Remove o listener anterior para evitar chamadas duplicadas
            select.removeEventListener('change', (e) => toggleOptionsVisibility(e.target));

            // Adiciona o novo listener
            select.addEventListener('change', (e) => toggleOptionsVisibility(e.target));

            // Inicializa a visibilidade no carregamento
            toggleOptionsVisibility(select);
        });

        // Listeners para Botão Adicionar Opção (Cinza)
        formContainer.querySelectorAll('.js-add-option').forEach(button => {
            button.removeEventListener('click', addOptionField);
            button.addEventListener('click', addOptionField);
        });

        // Listener para Botão Adicionar Questão (Roxo)
        const mainAddQuestionButton = formContainer.querySelector('.js-add-question');
        if (mainAddQuestionButton) {
            mainAddQuestionButton.removeEventListener('click', addNewQuestionBlock);
            mainAddQuestionButton.addEventListener('click', addNewQuestionBlock);
        }
    };

    // Inicia a atribuição de listeners na carga da página
    attachListeners();
});