document.addEventListener('turbo:load', () => {
    const formContainer = document.querySelector('.template-form-container');
    if (!formContainer) return;

    let questionIndex = 0; // começa em 0 para nested attributes do Rails
    let optionCounters = {}; // salva quantas opções cada questão tem

    // Alterna visibilidade de opções
    const toggleOptionsVisibility = (typeSelect) => {
        const questionBlock = typeSelect.closest('.js-question-block');
        if (!questionBlock) return;

        const optionsContainer = questionBlock.querySelector('.js-options-container');
        const addOptionButton = questionBlock.querySelector('.js-add-option-button');

        if (typeSelect.value === 'Radio') {
            optionsContainer.classList.remove('hidden');
            addOptionButton.classList.remove('hidden');
        } else {
            optionsContainer.classList.add('hidden');
            addOptionButton.classList.add('hidden');
        }
    };

    // Adicionar nova opção
    const addOptionField = (event) => {
        event.preventDefault();

        const questionBlock = event.target.closest('.js-question-block');
        const qIndex = questionBlock.dataset.qindex;
        const optionList = questionBlock.querySelector('.js-options-list');

        if (!optionCounters[qIndex]) optionCounters[qIndex] = 1;
        const optionIndex = optionCounters[qIndex]++;

        const newOption = document.createElement('div');
        newOption.classList.add('mt-2');

        newOption.innerHTML = `
            <input 
                name="template[questao_templates_attributes][${qIndex}][options_attributes][${optionIndex}][texto]"
                type="text"
                placeholder="Opção"
                class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1"
            >
        `;
        optionList.appendChild(newOption);
    };

    // Adicionar nova questão
    const addNewQuestionBlock = (event) => {
        event.preventDefault();

        const qIndex = questionIndex;
        optionCounters[qIndex] = 1;

        const newQuestionHTML = `
            <div class="mb-6 border-b border-gray-200 pb-4 js-question-block" data-qindex="${qIndex}">
                <h2 class="text-xl font-bold text-gray-800 mb-4">Questão ${qIndex + 1}</h2>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Tipo:</label>
                        <select 
                            name="template[questao_templates_attributes][${qIndex}][tipo]"
                            class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1 js-type-select">
                            <option value="Radio">Multipla Escolha</option>
                            <option value="Texto">Texto</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700">Texto:</label>
                        <input 
                            name="template[questao_templates_attributes][${qIndex}][texto]"
                            type="text"
                            placeholder="Placeholder"
                            class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1">
                    </div>
                </div>

                <div class="mt-4 js-options-container">
                    <label class="block text-sm font-medium text-gray-700">Opções:</label>
                    <div class="js-options-list">
                        <input 
                            name="template[questao_templates_attributes][${qIndex}][options_attributes][0][texto]"
                            type="text"
                            placeholder="Opção 1"
                            class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1">
                    </div>
                </div>

                <div class="mt-4 flex justify-center js-add-option-button">
                    <button type="button"
                        class="h-8 w-8 rounded-full bg-gray-300 text-gray-700 hover:bg-gray-400 flex items-center justify-center js-add-option">
                        <span class="text-xl font-light">+</span>
                    </button>
                </div>
            </div>
        `;

        const container = formContainer.querySelector('#questions-container');
        container.insertAdjacentHTML('beforeend', newQuestionHTML);

        questionIndex++;

        attachListeners();
    };

    // Aplicar listeners
    const attachListeners = () => {
        formContainer.querySelectorAll('.js-type-select').forEach(select => {
            select.addEventListener('change', (e) => toggleOptionsVisibility(e.target));
            toggleOptionsVisibility(select);
        });

        formContainer.querySelectorAll('.js-add-option').forEach(button => {
            button.addEventListener('click', addOptionField);
        });

        const mainAddQuestionButton = formContainer.querySelector('.js-add-question');
        if (mainAddQuestionButton) {
            mainAddQuestionButton.addEventListener('click', addNewQuestionBlock);
        }
    };

    attachListeners();
});
