document.addEventListener('turbo:load', () => {
    const formContainer = document.querySelector('.template-form-container');
    if (!formContainer) return;

    // Inicializa o índice global de questões para NOVOS campos.
    // O valor inicial é o número de blocos existentes na página (para que novos IDs não se sobreponham).
    let questionIndex = formContainer.querySelectorAll('.js-question-block').length; 
    let optionCounters = {}; 

    // --- Lógica de Remoção (Marca para exclusão ou remove do DOM) ---
    const removeNestedItem = (event) => {
        event.preventDefault();
        // Item pode ser o bloco da Questão (.js-question-block) ou Opção (.js-option-item)
        const itemToRemove = event.target.closest('.js-question-block') || event.target.closest('.js-option-item');
        if (!itemToRemove) return;

        // O campo _destroy é necessário para dizer ao Rails para deletar no banco.
        const destroyField = itemToRemove.querySelector('input[name*="_destroy"]');

        if (destroyField) {
            // Se tem _destroy (item existe no banco ou foi recém-criado na tela):
            destroyField.value = '1'; 
            itemToRemove.style.display = 'none'; // Esconde visualmente (soft delete)
        } else {
            // Se não tem (item criado e deletado antes de salvar), apenas remove do DOM:
            itemToRemove.remove();
        }
    };

    // --- Lógica de Criação ---

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

    // ADICIONAR NOVA OPÇÃO (CORRIGIDO: NOME DA ASSOCIAÇÃO)
    const addOptionField = (event) => {
        event.preventDefault();

        const questionBlock = event.target.closest('.js-question-block');
        // Pega o índice único da questão pai
        const qIndex = questionBlock.dataset.qindex; 
        const optionList = questionBlock.querySelector('.js-options-list');

        // Garante que o contador comece do zero para novos índices
        if (optionCounters[qIndex] === undefined) {
             // Se for a primeira vez, conta as existentes para continuar
            optionCounters[qIndex] = questionBlock.querySelectorAll('.js-option-item').length;
        }
        
        const optionIndex = new Date().getTime(); // Usar timestamp para índice único (Rails)

        const newOption = document.createElement('div');
        newOption.classList.add('mt-2', 'js-option-item');

        newOption.innerHTML = `
            <div class="flex items-center space-x-2 mt-2 js-option-item">
                <input type="hidden" name="template[questao_templates_attributes][${qIndex}][opcao_templates_attributes][${optionIndex}][id]" value="">
                
                <input type="hidden" name="template[questao_templates_attributes][${qIndex}][opcao_templates_attributes][${optionIndex}][_destroy]" value="false" class="js-destroy-option-checkbox">
                
                <input type="hidden" name="template[questao_templates_attributes][${qIndex}][opcao_templates_attributes][${optionIndex}][numero_opcao]" value="${optionCounters[qIndex] + 1}">

                <input 
                    name="template[questao_templates_attributes][${qIndex}][opcao_templates_attributes][${optionIndex}][texto_opcao]"
                    type="text"
                    placeholder="Opção"
                    class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1"
                >
                <button type="button" class="text-red-500 hover:text-red-700 text-sm js-remove-option-btn">X</button>
            </div>
        `;
        optionList.appendChild(newOption);
        
        // Atribui listener ao novo botão de remoção
        newOption.querySelector('.js-remove-option-btn').addEventListener('click', removeNestedItem);
        optionCounters[qIndex]++; // Incrementa o contador de opções para a próxima
    };

    // ADICIONAR NOVA QUESTÃO (CORRIGIDO: INCLUSÃO DE CAMPOS OBRIGATÓRIOS)
    const addNewQuestionBlock = (event) => {
        event.preventDefault();

        // Usa o índice global e incrementa
        const qIndex = new Date().getTime(); // Timestamp para índice único (importante para novos)
        optionCounters[qIndex] = 0; 

        const newQuestionHTML = `
            <div class="mb-6 border-b border-gray-200 pb-4 js-question-block" data-qindex="${qIndex}">
                <h2 class="text-xl font-bold text-gray-800 mb-4">Nova Questão</h2>

                <input type="hidden" name="template[questao_templates_attributes][${qIndex}][id]" value="">
                
                <input type="hidden" name="template[questao_templates_attributes][${qIndex}][_destroy]" value="false" class="js-destroy-question-checkbox">

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Tipo:</label>
                        <select 
                            name="template[questao_templates_attributes][${qIndex}][tipo_resposta]"
                            class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1 js-type-select">
                            <option value="Radio">Multipla Escolha</option>
                            <option value="Texto">Texto</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700">Texto:</label>
                        <input 
                            name="template[questao_templates_attributes][${qIndex}][texto_questao]"
                            type="text"
                            placeholder="Texto da Questão"
                            class="mt-1 block w-full border-b border-gray-300 focus:border-purple-600 focus:outline-none py-1">
                    </div>
                </div>

                <div class="mt-4 js-options-container">
                    <label class="block text-sm font-medium text-gray-700">Opções:</label>
                    <div class="js-options-list">
                        </div>
                </div>

                <div class="mt-4 flex justify-center js-add-option-button">
                    <button type="button"
                        class="h-8 w-8 rounded-full bg-gray-300 text-gray-700 hover:bg-gray-400 flex items-center justify-center js-add-option">
                        <span class="text-xl font-light">+</span>
                    </button>
                </div>

                <div class="mt-2 text-right">
                    <button type="button" class="text-red-500 hover:text-red-700 text-sm js-remove-question">Remover Questão</button>
                </div>
            </div>
        `;

        const container = formContainer.querySelector('#questions-container');
        container.insertAdjacentHTML('beforeend', newQuestionHTML);

        questionIndex++; // Incrementa o índice global (embora qIndex seja timestamp, o count é útil)

        // Atacha listeners para o novo bloco
        attachListeners();
    };


    // --- Inicialização e Reaplicação de Listeners ---
    const attachListeners = () => {
        // 1. Visibilidade de Opções
        formContainer.querySelectorAll('.js-type-select').forEach(select => {
            select.removeEventListener('change', (e) => toggleOptionsVisibility(e.target)); 
            select.addEventListener('change', (e) => toggleOptionsVisibility(e.target));
            toggleOptionsVisibility(select);
        });

        // 2. Adicionar Opção
        formContainer.querySelectorAll('.js-add-option').forEach(button => {
            button.removeEventListener('click', addOptionField); 
            button.addEventListener('click', addOptionField);
        });
        
        // 3. Remover Questão
        formContainer.querySelectorAll('.js-remove-question').forEach(button => {
            button.removeEventListener('click', removeNestedItem); 
            button.addEventListener('click', removeNestedItem);
        });

        // 4. Remover Opção (Botões X)
        formContainer.querySelectorAll('.js-remove-option-btn').forEach(button => {
            button.removeEventListener('click', removeNestedItem); 
            button.addEventListener('click', removeNestedItem);
        });

        // 5. Adicionar Questão (Botão Principal)
        const mainAddQuestionButton = formContainer.querySelector('.js-add-question');
        if (mainAddQuestionButton) {
            mainAddQuestionButton.removeEventListener('click', addNewQuestionBlock); 
            mainAddQuestionButton.addEventListener('click', addNewQuestionBlock);
        }
        
        // 6. INICIALIZAR data-qindex e optionCounters para campos existentes (ESSENCIAL PARA EDIÇÃO)
        formContainer.querySelectorAll('.js-question-block').forEach((block, index) => {
             if (!block.dataset.qindex) {
                // Para campos existentes, usamos o índice sequencial para o JS
                block.dataset.qindex = index; 
                
                // Inicializa o contador de opções com base no que já está na tela
                const existingOptionsCount = block.querySelectorAll('.js-option-item').length;
                optionCounters[index] = existingOptionsCount;
             }
        });
    };
    
    attachListeners();
});